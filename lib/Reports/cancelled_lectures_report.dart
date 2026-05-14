import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Data/Model/unfinished_lecture_model.dart';

class CancelledLecturesPdfWidgets {
  /// ✅ يعرض المحاضرات فقط (بدون أيام فاضية) + يدعم أكثر من صفحة مثل تقرير الإشعارات
  /// ✅ ترتيب الأعمدة (مثل اللي عندك الآن): الدكتور | المادة | اليوم | م
  static List<pw.Widget> buildTable({
    required List<UnfinishedLecture> lectures,
    required pw.Font font,
    required pw.Font bold,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) {
    pw.Widget cell(String t, {bool header = false, pw.Alignment align = pw.Alignment.center}) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        alignment: align,
        child: pw.Text(
          t,
          style: pw.TextStyle(font: header ? bold : font, fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),
      );
    }

    // ✅ ناخذ فقط اللي داخل الفترة + نرتب حسب اليوم (ثم اسم الدكتور/المادة لو تحب)
    // ignore: unused_local_variable
    final fmt = DateFormat('yyyy-MM-dd');

    final data = lectures.where((l) {
      final d = _readDay(l);
      if (d.trim().isEmpty) return false;
      try {
        final dt = DateTime.parse(d);
        return !dt.isBefore(DateTime(dateFrom.year, dateFrom.month, dateFrom.day)) &&
            !dt.isAfter(DateTime(dateTo.year, dateTo.month, dateTo.day));
      } catch (_) {
        // لو اليوم جاك كنص غير قابل للتحويل، نخليه يمر (عشان ما يختفي)
        return true;
      }
    }).toList();

    // ✅ ترتيب حسب اليوم تصاعدي
    data.sort((a, b) {
      final da = _readDay(a);
      final db = _readDay(b);
      return da.compareTo(db);
    });

    const int rowsPerPage = 17;

    pw.Table oneTable(int start, int end) {
      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey700, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(2.8), // الدكتور
          1: pw.FlexColumnWidth(3.2), // المادة
          2: pw.FlexColumnWidth(2.2), // اليوم
          3: pw.FlexColumnWidth(0.8), // م
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey300),
            children: [
              cell('الدكتور', header: true),
              cell('المادة', header: true),
              cell('اليوم', header: true),
              cell('م', header: true),
            ],
          ),
          ...List.generate(end - start, (idx) {
            final i = start + idx;
            final l = data[i];

            final day = _readDay(l);
            final dayKey = day.trim().isEmpty ? '' : day;

            return pw.TableRow(
              children: [
                cell(_readDoctor(l)),
                cell(_readSubject(l)),
                cell(dayKey),
                cell('${i + 1}'),
              ],
            );
          }),
        ],
      );
    }

    // ✅ لو مافي بيانات فعلاً داخل الفترة: جدول هيدر فقط (بدون صفوف)
    if (data.isEmpty) {
      return [
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey700, width: 1),
          columnWidths: const {
            0: pw.FlexColumnWidth(2.8),
            1: pw.FlexColumnWidth(3.2),
            2: pw.FlexColumnWidth(2.2),
            3: pw.FlexColumnWidth(0.8),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                cell('الدكتور', header: true),
                cell('المادة', header: true),
                cell('اليوم', header: true),
                cell('م', header: true),
              ],
            ),
          ],
        ),
      ];
    }

    final List<pw.Widget> out = [];

    for (int start = 0; start < data.length; start += rowsPerPage) {
      final end = (start + rowsPerPage > data.length) ? data.length : (start + rowsPerPage);

      out.add(oneTable(start, end));

      if (end < data.length) {
        out.add(pw.SizedBox(height: 8));
        out.add(pw.NewPage());
      }
    }

    return out;
  }

  // ===== readers (مثل ما هي عندك) =====
  static String _readDay(UnfinishedLecture l) {
    try {
      final v = (l as dynamic).eventDay;
      return v?.toString() ?? '';
    } catch (_) {}
    try {
      final v = (l as dynamic).event_day;
      return v?.toString() ?? '';
    } catch (_) {}
    return '';
  }

  static String _readSubject(UnfinishedLecture l) {
    try {
      final v = (l as dynamic).subjectName;
      return v?.toString() ?? '';
    } catch (_) {}
    try {
      final v = (l as dynamic).subject_name;
      return v?.toString() ?? '';
    } catch (_) {}
    return '';
  }

  static String _readDoctor(UnfinishedLecture l) {
    try {
      final v = (l as dynamic).doctorName;
      return v?.toString() ?? '';
    } catch (_) {}
    try {
      final v = (l as dynamic).doctor_name;
      return v?.toString() ?? '';
    } catch (_) {}
    return '';
  }
}
