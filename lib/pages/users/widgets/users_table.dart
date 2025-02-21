import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crabcheckweb1/services/firestore.dart';

import '../../../constants/colors.dart';

class UsersTable extends StatefulWidget {
  const UsersTable({super.key});

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  // call services
  final FirestoreService _firestoreService = FirestoreService();

  static const _rowsPerPage = 5;

  int _currentPage = 0;

  // dropdown button variables
  String selectedYear = DateTime.now().year.toString();
  List<String> years = [];

  @override
  void initState() {
    super.initState();
    generateYears();
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
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: (56 * _rowsPerPage) + 80,
          child: _buildTable(),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestoreService.getFilteredCrabReports(selectedYear),
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
            allRows.length <= 4
                ? Container()
                : _buildPaginationControls(allRows.length),
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
      DataColumn2(size: ColumnSize.L, label: Text("Name", style: textStyle)),
      DataColumn2(
          size: ColumnSize.L, label: Text('Occupation', style: textStyle)),
      DataColumn2(
        size: ColumnSize.L,
        label: Text('Address', style: textStyle),
      ),
    ];
  }

  List<DataRow> _createDataRows(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      // final timestamp = data['timestamp'] as Timestamp?;

      return DataRow(cells: [
        DataCell(Text(data['name']?.toString() ?? 'Unspecified')),
        DataCell(Text(data['occupation']?.toString() ?? 'Unspecified')),
        DataCell(Text(data['userAddress']?.toString() ?? 'Unknown location')),
      ]);
    }).toList();
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
