import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../services/firestore.dart';
import '../../../services/printing_service.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  final FirestoreService _firestoreService = FirestoreService();
  final PrintingService _printingService = PrintingService();

  int _rowsPerPage = 5;
  static final DateFormat _dateFormat = DateFormat('MMMM d, yyyy HH:mm');

  int _currentPage = 0;
  String selectedYear = DateTime.now().year.toString();
  List<String> years = [];
  List<String> view = ['Classified', 'Unclassified'];
  String selectedView = 'Classified';
  late ReportDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    generateYears();
    _dataSource = ReportDataSource(context, [], selectedView);
  }

  void generateYears() {
    int currentYear = DateTime.now().year;
    for (int i = -1; i < 5; i++) {
      years.add((currentYear + i).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilters(),
        SizedBox(height: 400, width: double.infinity, child: _buildTable()),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedView,
          items: view.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedView = value!;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.print, color: Colors.black87),
          onPressed: _printingService.printReport,
        ),
        DropdownButton<String>(
          value: selectedYear,
          items: years.map((year) {
            return DropdownMenuItem(value: year, child: Text(year));
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedYear = value!;
            });
          },
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
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: SvgPicture.asset('lib/assets/svg/empty-data.svg',
                  height: 200, width: 200));
        }

        final data = snapshot.data!.docs.map((doc) {
          final d = doc.data();
          return ReportModel(
            id: doc.id,
            image: d['image'] ?? '',
            species: d['species'] ?? 'Unknown',
            edibility: d['edibility'] ?? 'Unknown',
            address: d['address'] ?? 'Unknown location',
            dateTime: d['timestamp'] != null
                ? _dateFormat.format(d['timestamp'].toDate())
                : 'Unknown',
          );
        }).toList();

        _dataSource = ReportDataSource(context, data, selectedView);

        return PaginatedDataTable(
          header: const Text('Reports'),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const [5, 10, 20],
          onRowsPerPageChanged: (int? value) {
            setState(() {
              _rowsPerPage = value!;
            });
          },
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          columns: _buildColumns(),
          source: _dataSource,
        );
      },
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text('Image')),
      const DataColumn(label: Text('Species')),
      const DataColumn(label: Text('Edibility')),
      const DataColumn(label: Text('Address')),
      const DataColumn(label: Text('Date & Time')),
    ];
  }
}

class ReportModel {
  final String id;
  final String image;
  final String species;
  final String edibility;
  final String address;
  final String dateTime;

  ReportModel({
    required this.id,
    required this.image,
    required this.species,
    required this.edibility,
    required this.address,
    required this.dateTime,
  });
}

class ReportDataSource extends DataTableSource {
  final BuildContext context;
  final List<ReportModel> reports;
  final String selectedView;

  ReportDataSource(this.context, this.reports, this.selectedView);

  @override
  DataRow getRow(int index) {
    final ReportModel report = reports[index];
    return DataRow(cells: [
      DataCell(Text(report.image)),
      DataCell(Text(report.species)),
      DataCell(Text(report.edibility)),
      DataCell(Text(report.address)),
      DataCell(Text(report.dateTime)),
    ]);
  }

  @override
  int get rowCount => reports.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
