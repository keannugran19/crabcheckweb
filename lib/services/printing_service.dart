// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
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

    // Add page to PDF with custom table and A4 paper size
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Crab Classification Report',
                        style: const pw.TextStyle(fontSize: 24)),
                    pw.Text(
                        'Generated on: ${DateFormat('MMM. d, yyyy').format(DateTime.now())}'),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    // Add headers
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Species',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Edibility',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Address',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Date',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Add data rows
                    ...dataRows.map((row) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                row['species']?.toString() ?? 'Unknown'),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                row['edibility']?.toString() ?? 'Unknown'),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(row['address']?.toString() ??
                                'Unknown address'),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                row['timestamp']?.toString() ?? 'No Date'),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save PDF as bytes
    final bytes = await pdf.save();

    // Create and download the PDF
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'report.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
