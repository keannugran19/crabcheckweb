import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:crabcheckweb1/services/firestore.dart';

import '../../../constants/colors.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  static const _rowsPerPage = 5;
  static final _dateFormat = DateFormat('MMMM d, yyyy HH:mm');

  final FirestoreService _firestoreService = FirestoreService();
  int _currentPage = 0;

  // dropdown button variables
  String selectedYear = DateTime.now().year.toString();
  List<String> years = [];
  List<String> view = ['Classified', 'Unclassified'];
  String selectedView = 'Classified';

  @override
  void initState() {
    super.initState();
    generateYears();
  }

  void _onYearChanged(String? value) {
    setState(() {
      selectedYear = value!;
      _currentPage = 0;
    });
  }

  // generate years for dropdown button
  void generateYears() {
    int currentYear = DateTime.now().year;
    for (int i = -1; i < 5; i++) {
      years.add((currentYear + i).toString());
    }
  }

  // display this widget when there is no data
  Widget hasNoData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'lib/assets/svg/empty-data.svg',
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 15),
        const Text(
          "Empty Data",
          style: TextStyle(
              fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFilters(),
        SizedBox(
          height: (56 * _rowsPerPage) + 80,
          child: _buildTable(),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedView,
          hint: const Text("Select View"),
          items: view.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedView = value!;
            });
          },
        ),
        DropdownButton<String>(
          value: selectedYear,
          hint: const Text("Select Year"),
          items: years.map((year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(year),
            );
          }).toList(),
          onChanged: _onYearChanged,
        ),
      ],
    );
  }

  Widget _buildTable() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: selectedView == 'Classified'
          ? _firestoreService.getFilteredCrabReports(selectedYear)
          : _firestoreService.getFilteredUnclassified(selectedYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return hasNoData();
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

    return selectedView == 'Classified'
        ? const [
            DataColumn2(
                size: ColumnSize.S, label: Text("Image", style: textStyle)),
            DataColumn2(
                size: ColumnSize.M, label: Text("Species", style: textStyle)),
            DataColumn2(
                size: ColumnSize.S, label: Text('Edibility', style: textStyle)),
            DataColumn2(
              size: ColumnSize.L,
              label: Text('Address', style: textStyle),
            ),
            DataColumn2(
                size: ColumnSize.L,
                label: Text('Date & Time', style: textStyle)),
            DataColumn2(size: ColumnSize.S, label: Text('')),
          ]
        : const [
            DataColumn2(
                size: ColumnSize.S, label: Text("Image", style: textStyle)),
            DataColumn2(
                size: ColumnSize.S, label: Text("Type", style: textStyle)),
            DataColumn2(
                size: ColumnSize.L, label: Text('Comment', style: textStyle)),
            DataColumn2(
                size: ColumnSize.M,
                label: Text('Date & Time', style: textStyle)),
            DataColumn2(size: ColumnSize.S, label: Text(''))
          ];
  }

  List<DataRow> _createDataRows(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?;

      return selectedView == 'Classified'
          ? DataRow(cells: [
              DataCell(
                GestureDetector(
                  onTap: () {
                    // Show the image preview dialog when the image is tapped
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: InteractiveViewer(
                          child: Image.network(
                            data['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  child: _firestoreService.buildImageCell(data['image']),
                ),
              ),
              DataCell(Text(data['species']?.toString() ?? 'Unknown')),
              DataCell(Text(data['edibility']?.toString() ?? 'Unknown')),
              DataCell(Text(data['address']?.toString() ?? 'Unknown location')),
              DataCell(Text(_formatTimestamp(timestamp))),
              DataCell(_buildDeleteButton(doc.id)),
            ])
          : DataRow(cells: [
              DataCell(
                GestureDetector(
                  onTap: () {
                    // Show the image preview dialog when the image is tapped
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: InteractiveViewer(
                          child: Image.network(
                            data['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  child: _firestoreService.buildImageCell(data['image']),
                ),
              ),
              const DataCell(Text("Unclassified")),
              DataCell(Text(data['specify']?.toString() ?? 'Not specified')),
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
