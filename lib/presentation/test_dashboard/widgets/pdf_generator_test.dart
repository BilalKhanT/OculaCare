import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportGenerator {
  final String userName;
  final String testDate;
  final String testType;
  final String testName;
  final int testScore;
  final String analysis;
  final String recommendations;
  final String impacts;
  final String userProfileImageBase64;

  PdfReportGenerator({
    required this.userName,
    required this.testDate,
    required this.testType,
    required this.testName,
    required this.testScore,
    required this.analysis,
    required this.recommendations,
    required this.impacts,
    required this.userProfileImageBase64,
  });

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final userProfileImage = _convertBase64ToImage(userProfileImageBase64);
    const circleSize = 100.0;

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.blue, width: 2),
                    image: pw.DecorationImage(
                      image: userProfileImage,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
                pw.Text(
                  "Test Report",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Name: $userName', style: const pw.TextStyle(fontSize: 16)),
            pw.Text('Date: $testDate', style: const pw.TextStyle(fontSize: 16)),
            pw.Text('Test Type: $testType', style: const pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            pw.Text('Test Name: $testName', style: const pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            _buildScoreWidget(testScore),
            pw.SizedBox(height: 20),
            pw.Text(
              'Analysis:',
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
            ),
            pw.Text(analysis, style: const pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text(
              'Recommendations:',
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
            ),
            pw.Text(recommendations, style: const pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text(
              'Impacts:',
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
            ),
            pw.Text(impacts, style: const pw.TextStyle(fontSize: 14)),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.ImageProvider _convertBase64ToImage(String base64String) {
    final bytes = base64Decode(base64String);
    return pw.MemoryImage(bytes);
  }

  pw.Widget _buildScoreWidget(int score) {
    return pw.Center(
      child: pw.Container(
        height: 120,
        width: 120,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          children: [
            pw.Container(
              height: 120,
              width: 120,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: score >= 8 ? PdfColors.green100 : score >= 6 ? PdfColors.yellow100 : score >= 3 ? PdfColors.orange100 : PdfColors.red100,
              ),
            ),
            pw.Text(
              testName == 'Snellan Chart' ? '6/$score' : '$score',
              style: pw.TextStyle(
                fontSize: 40,
                fontWeight: pw.FontWeight.bold,
                color: score >= 8 ? PdfColors.green900 : score >= 6 ? PdfColors.yellow900 : score >= 3 ? PdfColors.orange900 : PdfColors.red900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void downloadReport(BuildContext context, PdfReportGenerator report) async {
  final pdfBytes = await report.generatePdf();

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdfBytes,
  );
}
