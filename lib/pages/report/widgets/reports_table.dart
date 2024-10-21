import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crabcheckweb1/services/firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  final FirestoreService firestoreService = FirestoreService();
  String? selectedYear; // Holds the selected year
  final List<String> years = [
    '2024',
    '2025',
    '2026',
    '2027',
    '2028'
  ]; // Available years for sorting

  final int _rowsPerPage = 5; // Number of rows per page for pagination
  int _currentPage = 0; // Current page index

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dropdown Button for selecting year
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton<String>(
              value: selectedYear,
              hint: const Text("Select Year"),
              items: years.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                  _currentPage = 0; // Reset to first page when year is changed
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: (56 * 5) + 40,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _getSortedStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final rows = _createRows(snapshot.data!);
              final paginatedRows = _paginateRows(rows);

              return Column(
                children: [
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 20,
                      horizontalMargin: 12,
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.withOpacity(0.1),
                      ),
                      dividerThickness: 0.5,
                      dataRowColor: WidgetStateProperty.all(Colors.white),
                      columns: [
                        DataColumn2(
                          size: ColumnSize.S,
                          label: Text("Image", style: _cellTextStyle),
                        ),
                        DataColumn2(
                          size: ColumnSize.M,
                          label: Text("Species", style: _cellTextStyle),
                        ),
                        DataColumn2(
                          size: ColumnSize.S,
                          label: Text('Edibility', style: _cellTextStyle),
                        ),
                        DataColumn2(
                          size: ColumnSize.L,
                          label: Text('Location (Latitude & Longitude)',
                              style: _cellTextStyle),
                        ),
                        DataColumn2(
                          size: ColumnSize.L,
                          label: Text('Date & Time', style: _cellTextStyle),
                        ),
                        const DataColumn2(
                          size: ColumnSize.S,
                          label: Text(''),
                        ),
                      ],
                      rows: paginatedRows,
                    ),
                  ),
                  _buildPaginationControls(rows.length),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Pagination Controls
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
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.blueGrey,
                onPressed: (_currentPage + 1) < totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Paginate rows based on the current page and rows per page
  List<DataRow> _paginateRows(List<DataRow> rows) {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  // Stream sorted by the selected year
  Stream<QuerySnapshot<Map<String, dynamic>>> _getSortedStream() {
    if (selectedYear != null) {
      DateTime start = DateTime(int.parse(selectedYear!), 1, 1);
      DateTime end = DateTime(int.parse(selectedYear!) + 1, 1, 1);

      return firestoreService.crabs
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return firestoreService.crabs
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  // Create rows from snapshot
  List<DataRow> _createRows(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final image = data['image']?.toString() ?? "No Image";
      final species = data['species']?.toString() ?? 'Unknown';
      final edibility = data['edibility']?.toString() ?? 'Unknown';
      final location = data['location'] as GeoPoint?;
      final timestamp = data['timestamp'] as Timestamp?;

      final locationText = location != null
          ? 'Lat: ${location.latitude.toStringAsFixed(6)}, '
              'Lng: ${location.longitude.toStringAsFixed(6)}'
          : 'Unknown';
      final dateTimeText = timestamp != null
          ? DateFormat('MMMM d, yyyy HH:mm').format(timestamp.toDate())
          : 'Unknown';

      return DataRow(cells: [
        DataCell(Image.network(image, width: 60, height: 60)),
        DataCell(Text(species, style: _cellTextStyle)),
        DataCell(Text(edibility, style: _cellTextStyle)),
        DataCell(Text(locationText, style: _cellTextStyle)),
        DataCell(Text(dateTimeText, style: _cellTextStyle)),
        DataCell(Center(
          child: IconButton(
            onPressed: () async {
              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this data?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                await firestoreService.crabs.doc(doc.id).delete();
              }
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
          ),
        )),
      ]);
    }).toList();
  }

  TextStyle get _cellTextStyle => const TextStyle(
        color: Colors.black87,
        fontSize: 14,
      );
}
