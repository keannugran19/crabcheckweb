import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:crabcheckweb1/services/firestore.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  static const _rowsPerPage = 5;
  static const List<String> _years = ['2024', '2025', '2026', '2027', '2028'];
  static final _dateFormat = DateFormat('MMMM d, yyyy HH:mm');

  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedYear;
  int _currentPage = 0;

  void _onYearChanged(String? value) {
    setState(() {
      _selectedYear = value;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildYearFilter(),
        SizedBox(
          height: (56 * _rowsPerPage) + 80,
          child: _buildTable(),
        ),
      ],
    );
  }

  Widget _buildYearFilter() {
    return Align(
      alignment: Alignment.centerRight,
      child: DropdownButton<String>(
        value: _selectedYear,
        hint: const Text("Select Year"),
        items: _years.map((year) {
          return DropdownMenuItem<String>(
            value: year,
            child: Text(year),
          );
        }).toList(),
        onChanged: _onYearChanged,
      ),
    );
  }

  Widget _buildTable() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestoreService.getFilteredStream(_selectedYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final allRows = _createDataRows(snapshot.data!);
        final paginatedRows = _paginateRows(allRows);

        return Column(
          children: [
            Expanded(child: _buildDataTable(paginatedRows)),
            _buildPaginationControls(allRows.length),
          ],
        );
      },
    );
  }

  Widget _buildDataTable(List<DataRow> rows) {
    return DataTable2(
      columnSpacing: 20,
      horizontalMargin: 12,
      headingRowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.1)),
      dividerThickness: 0.5,
      dataRowColor: WidgetStateProperty.all(Colors.white),
      columns: _buildColumns(),
      rows: rows,
    );
  }

  List<DataColumn2> _buildColumns() {
    const textStyle = TextStyle(color: Colors.black87, fontSize: 14);

    return const [
      DataColumn2(size: ColumnSize.S, label: Text("Image", style: textStyle)),
      DataColumn2(size: ColumnSize.M, label: Text("Species", style: textStyle)),
      DataColumn2(
          size: ColumnSize.S, label: Text('Edibility', style: textStyle)),
      DataColumn2(
        size: ColumnSize.L,
        label: Text('Address', style: textStyle),
      ),
      DataColumn2(
          size: ColumnSize.L, label: Text('Date & Time', style: textStyle)),
      DataColumn2(size: ColumnSize.S, label: Text('')),
    ];
  }

  List<DataRow> _createDataRows(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?;

      return DataRow(cells: [
        DataCell(_firestoreService.buildImageCell(data['image'])),
        DataCell(Text(data['species']?.toString() ?? 'Unknown')),
        DataCell(Text(data['edibility']?.toString() ?? 'Unknown')),
        DataCell(Text(data['address']?.toString() ?? 'Unknown location')),
        DataCell(Text(_formatTimestamp(timestamp))),
        DataCell(_buildDeleteButton(doc.id)),
      ]);
    }).toList();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    return timestamp != null
        ? _dateFormat.format(timestamp.toDate())
        : 'Unknown';
  }

  Widget _buildDeleteButton(String docId) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Delete',
        onPressed: () => _showDeleteConfirmation(docId),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(String docId) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _firestoreService.crabs.doc(docId).delete();
    }
  }

  List<DataRow> _paginateRows(List<DataRow> rows) {
    final start = _currentPage * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, rows.length);
    return rows.sublist(start, end);
  }

  Widget _buildPaginationControls(int totalRowCount) {
    final totalPages = (totalRowCount / _rowsPerPage).ceil();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Colors.blueGrey,
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.blueGrey,
                onPressed: (_currentPage + 1) < totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
