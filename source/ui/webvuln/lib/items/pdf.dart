import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> createPDF(newData, directoryPath, nameFile) async {
  String now = DateTime.now().toString();
  Map<String, dynamic> jsonData = jsonDecode(newData);
  // Create a temporary directory and remove it at the end
  final file = File('$directoryPath/$nameFile.pdf');
  file.createSync(recursive: true);
  String domain = jsonData["domain"];
  String scanDate = jsonData["scanDate"];
  String numVuln = jsonData["numVuln"].toString();
  String resultPoint = jsonData["resultPoint"].toString();
  String resultSeverity = jsonData["resultSeverity"].toString();
  String id = jsonData["_id"].toString();

  // Create a PDF document
  final doc = pw.Document();

  // Render the page
  doc.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table(
          children: <pw.TableRow>[
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 1,
                ),),
              children: <pw.Widget>[
                pw.Text('Domain'),
                pw.Text('Date & Time'),
                pw.Text('Number Vulnerabilities'),
                pw.Text('Result Point'),
                pw.Text('Result Severity'),
                pw.Text('ID')
              ],
            ),
            pw.TableRow(
              children: <pw.Widget>[
                pw.Text(domain),
                pw.Text(scanDate),
                pw.Text(numVuln),
                pw.Text(resultPoint),
                pw.Text(resultSeverity),
                pw.Text(id)
              ],
            ),
          ],
        );
      },
    ),
  );

  // Write the document to a file
  final Uint8List bytes = await doc.save();
  await file.writeAsBytes(bytes);

  // Print the file path to the console
  print('File saved to ${file.path}');
}
