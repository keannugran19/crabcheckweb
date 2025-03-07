// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';

class PrintingService {
  // Firestore collection reference
  final crabs = FirebaseFirestore.instance.collection('crabData');

  // padding
  var padding = const pw.EdgeInsets.all(8.0);

  // Printing function
  Future<void> printReport() async {
    final pdf = pw.Document();

    // Fetch data from Firestore
    final snapshot = await crabs.get();
    // sort data by timestamp
    final sortedData = snapshot.docs.map((doc) => doc.data()).toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    // Map Firestore data to table rows
    final dataRows = await Future.wait(sortedData.map((doc) async {
      final data = doc;
      // format date and time
      String formattedDate = 'No Date';
      if (data['timestamp'] != null) {
        DateTime timestamp = data['timestamp'].toDate();
        formattedDate = DateFormat('MMM. d, yyyy').format(timestamp);
      }

      return {
        'species': data['species']?.toString() ?? 'Unknown',
        'edibility': data['edibility']?.toString() ?? 'Unknown',
        'address': data['address']?.toString() ?? 'Unknown address',
        'timestamp': formattedDate,
      };
    }).toList());

    // build table
    pw.Widget buildTable(List<Map<String, dynamic>> dataRows) {
      return pw.TableHelper.fromTextArray(
        headers: ['Species', 'Edibility', 'Address', 'Date'],
        data: dataRows
            .map((row) => [
                  row['species'],
                  row['edibility'],
                  row['address'],
                  row['timestamp']
                ])
            .toList(),
        cellPadding: padding,
        cellAlignment: pw.Alignment.centerLeft,
        cellStyle: const pw.TextStyle(fontSize: 12),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      );
    }

    // header and footer of pdf
    final profileImage = pw.MemoryImage(
      (await rootBundle.load('lib/assets/images/headerfooter.png'))
          .buffer
          .asUint8List(),
    );

    // create pages
    pdf.addPage(
      pw.MultiPage(
          pageTheme: pw.PageTheme(
              margin:
                  const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 120),
              pageFormat: PdfPageFormat.a4,
              orientation: pw.PageOrientation.portrait,
              buildBackground: (pw.Context context) {
                return pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Image(profileImage, fit: pw.BoxFit.fill),
                );
              }),
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Crab Classification Report',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Generated on: ${DateFormat('MMM. d, yyyy').format(DateTime.now())}'),
                ],
              ),
              pw.SizedBox(height: 10),
              buildTable(dataRows),
              pw.SizedBox(height: 30),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Column(
                  children: [
                    pw.Text('Prepared By:_______________'),
                    pw.SizedBox(height: 30),
                    pw.Text('Reviewed By:_______________'),
                    pw.SizedBox(height: 30),
                    pw.Text('Approved By:_______________')
                  ],
                ),
              ])
            ];
          }),
    );

    // return pdf.save();

    // Save PDF as bytes
    final bytes = await pdf.save();

    // Create and download the PDF
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'crab_report.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
