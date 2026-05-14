import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../Data/Model/SentNotificationModel.dart';

class SentNotificationsPdfWidgets {
  static List<pw.Widget> buildTable({
    required List<SentNotification> rows,
    required pw.Font font,
    required pw.Font bold,
  }) {
    final data = [...rows]..sort((a, b) => b.notificationId.compareTo(a.notificationId));

    pw.Widget cell(String t, {bool header = false, pw.Alignment align = pw.Alignment.center}) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        alignment: align,
        child: pw.Text(
          t,
          style: pw.TextStyle(font: header ? bold : font, fontSize: 9),
          textAlign: pw.TextAlign.center,
        ),
      );
    }

    const int rowsPerPage = 17;

    pw.Table buildTablePage(int start, int end) {
      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey700, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(2.0),
          1: pw.FlexColumnWidth(3.0),
          2: pw.FlexColumnWidth(2.2),
          3: pw.FlexColumnWidth(2.0),
          4: pw.FlexColumnWidth(1.2),
          5: pw.FlexColumnWidth(1.6),
          6: pw.FlexColumnWidth(0.7),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey300),
            children: [
              cell('المرسل', header: true),
              cell('الوصف', header: true),
              cell('العنوان', header: true),
              cell('النوع', header: true),
              cell('الوقت', header: true),
              cell('التاريخ', header: true),
              cell('م', header: true),
            ],
          ),
          ...List.generate(end - start, (idx) {
            final i = start + idx;
            final r = data[i];
            return pw.TableRow(
              children: [
                cell(r.sender),
                cell(
                  _softWrapLongTokens(_sanitize(r.description)),
                  align: pw.Alignment.centerRight,
                ),
                cell(r.title),
                cell(r.type),
                cell(r.time),
                cell(r.date),
                cell('${i + 1}'),
              ],
            );
          }),
        ],
      );
    }

    final List<pw.Widget> out = [];
    int i = 0;
    while (i < data.length) {
      final end = (i + rowsPerPage > data.length) ? data.length : i + rowsPerPage;
      out.add(buildTablePage(i, end));
      i = end;
      if (i < data.length) {
        out.add(pw.NewPage());
      }
    }

    return out;
  }

  static String _sanitize(String text) {
    return text.replaceAll(
      RegExp(r'[^؀-ۿݐ-ݿࢠ-ࣿa-zA-Z0-9\s.,\-_:]'),
      '',
    );
  }

  static String _softWrapLongTokens(String text, {int step = 25}) {
    return text.replaceAllMapped(
      RegExp(r'\S{' + step.toString() + r',}'),
          (m) {
        final s = m.group(0)!;
        final buf = StringBuffer();
        for (int i = 0; i < s.length; i += step) {
          final end = (i + step < s.length) ? i + step : s.length;
          buf.write(s.substring(i, end));
          buf.write('\u200B');
        }
        return buf.toString();
      },
    );
  }
}
