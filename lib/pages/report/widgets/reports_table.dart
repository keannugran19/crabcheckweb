import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: (56 * 5) + 40,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("crabData")
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final rows = _createRows(snapshot.data!);
              return DataTable2(
                columnSpacing: 20,
                horizontalMargin: 12,
                minWidth: 600,
                headingRowColor: WidgetStateProperty.all(
                  Colors.grey.withOpacity(0.1),
                ),
                dividerThickness: 0.5,
                dataRowColor: WidgetStateProperty.all(
                  Colors.white,
                ),
                columns: const [
                  DataColumn2(
                    label: Text(
                      "Species",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Edibility',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Location (Latitude & Longitude)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date & Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
                rows: rows,
              );
            },
          ),
        ),
      ],
    );
  }

  List<DataRow> _createRows(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
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
        DataCell(Text(species, style: _cellTextStyle)),
        DataCell(Text(edibility, style: _cellTextStyle)),
        DataCell(Text(locationText, style: _cellTextStyle)),
        DataCell(Text(dateTimeText, style: _cellTextStyle)),
      ]);
    }).toList();
  }

  TextStyle get _cellTextStyle => const TextStyle(
        color: Colors.black87,
        fontSize: 14,
      );
}
