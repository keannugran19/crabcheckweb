import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class PrintingService {
  // call the collection
  final crabs = FirebaseFirestore.instance.collection('crabData');

  // printing function
  Future<void> printReport() async {
    final pdf = pw.Document();

    // Debugging: Print fetched data
    final snapshot = await crabs.get();
    if (snapshot.docs.isEmpty) {
      print('No data found in the crabs collection');
    } else {
      print('Fetched data: ${snapshot.docs.map((doc) => doc.data()).toList()}');
    }

    // Map Firestore data to table rows
    final dataRows = snapshot.docs.map((doc) {
      final data = doc.data();
      return [
        'No Image', // Placeholder for image logic
        data['species']?.toString() ?? 'Unknown',
        data['edibility']?.toString() ?? '',
        data['address']?.toString() ?? 'Unknown address',
        data['timestamp']?.toDate().toString() ?? 'No Date',
      ];
    }).toList();

    // Add page to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: [
              'Image',
              'Species',
              'Edibility',
              'Address',
              'Date & Time'
            ],
            data: dataRows,
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
