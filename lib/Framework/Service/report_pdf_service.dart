
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportPdfBase {
  static Future<pw.Font> _loadFont(String path) async {
    final data = await rootBundle.load(path);
    return pw.Font.ttf(data);
  }

  static Future<pw.ImageProvider> _loadLogo(String path) async {
    final data = await rootBundle.load(path);
    return pw.MemoryImage(data.buffer.asUint8List());
  }

  static Future<void> generate({
    required String title,
    required Map<String, String> headerInfo,
    required List<pw.Widget> Function(pw.Font font, pw.Font bold) bodyBuilder,
    required Future<void> Function(Uint8List bytes) onSave,
  }) async {
    final baseFont = await _loadFont('assets/fonts/Amiri-Regular.ttf');
    final boldFont = baseFont; // نفس الخط (كما طلبت)
    final logo = await _loadLogo('assets/images/ust_logo.png');

    final doc = pw.Document();

    final theme = pw.ThemeData.withFont(
      base: baseFont,
      bold: boldFont,
    );

    doc.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 22, 28, 22),
        build: (context) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _buildTopHeader(headerInfo, logo),
                pw.SizedBox(height: 10),
                _buildTitle(title, boldFont),
                pw.SizedBox(height: 8),
                _buildInfoBar(headerInfo, boldFont),
                pw.SizedBox(height: 10),
                ...bodyBuilder(baseFont, boldFont),
                pw.SizedBox(height: 18),
                _buildSignatures(headerInfo),
              ],
            ),
          ),
        ],
      ),
    );

    print('PDF: building done, saving...');
    final bytes = await doc.save();
    print('PDF: bytes=${bytes.length}');

    await onSave(bytes);
    print('PDF: onSave finished');
  }

  /// ✅ حفظ + فتح معاينة الطباعة
  static Future<void> saveAndOpenPdf(Uint8List bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    print('PDF: saved => ${file.path}  size=${await file.length()}');

    // ✅ هذا اللي يفتح شاشة الطباعة/المعاينة
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  static pw.Widget _buildTopHeader(
      Map<String, String> h,
      pw.ImageProvider logo,
      ) {
    final leftEn = (h['header_left_en'] ??
        'Republic of Yemen\nUniversity of Science and Technology\nFaculty of Computing &\nInformation Technology');
    final rightAr = (h['header_right_ar'] ??
        'الجمهورية اليمنية\nجامعة العلوم والتكنولوجيا\nكلية الحاسبات وتكنولوجيا المعلومات');

    final ref = h['ref'] ?? '';
    final dateEn = h['print_datetime'] ?? '';
    final dateAr = h['print_date_ar'] ?? '';

    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                rightAr,
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Container(
              width: 60,
              height: 60,
              alignment: pw.Alignment.center,
              child: pw.Image(
                logo,
                width: 52,
                height: 52,
                fit: pw.BoxFit.contain,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                leftEn,
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.left,
                textDirection: pw.TextDirection.ltr,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Divider(thickness: 1, color: PdfColors.grey700),
        pw.SizedBox(height: 4),

        /// ✅ ترتيب الرقم والتاريخ بشكل مرتب (عربي يمين + انجليزي يسار)
        /// ✅ عكسنا أماكن الرقم/التاريخ: (الإنجليزي يمين) + (العربي يسار)
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ✅ العربي يسار
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'الرقم: $ref',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.left,
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'التاريخ: $dateAr',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.left,
                  ),
                ],
              ),
            ),

            // ✅ الإنجليزي يمين
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Ref: $ref',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.right,
                    textDirection: pw.TextDirection.ltr,
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Date: $dateEn',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.right,
                    textDirection: pw.TextDirection.ltr,
                  ),
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }

  static pw.Widget _buildTitle(String title, pw.Font bold) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 14)),
        pw.SizedBox(height: 2),
        pw.Container(height: 0.6, width: 160, color: PdfColors.black),
        pw.SizedBox(height: 10),

      ],

    );

  }

  static pw.Widget _buildInfoBar(Map<String, String> h, pw.Font bold) {
    final spec = h['specialization'] ?? 'التخصص:';
    final level = h['level'] ?? 'المستوى:';
    final group = h['group'] ?? 'المجموعة:';

    pw.Widget box(String text) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        border: pw.Border.all(color: PdfColors.grey700, width: 1),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: bold, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );

    return pw.Row(
      children: [
        pw.Expanded(child: box(spec)),
        pw.SizedBox(width: 6),
        pw.Expanded(child: box(level)),
        pw.SizedBox(width: 6),
        pw.Expanded(child: box(group)),
      ],
    );
  }

  static pw.Widget _buildSignatures(Map<String, String> h) {
    final right = h['sig_right'] ?? 'المختص';
    final mid = h['sig_mid'] ?? 'رئيس القسم';
    final left = h['sig_left'] ?? 'عميد الكلية';

    pw.Widget sig(String t) => pw.Column(
      children: [
        pw.Text(t, style: const pw.TextStyle(fontSize: 15)),
        pw.SizedBox(height: 30),
      ],
    );

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        sig(right),
        sig(mid),
        sig(left),
      ],
    );
  }
}
