import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

class EodSummaryExportService {
  const EodSummaryExportService();

  Future<File> SaveCsv({
    required EodSummaryDetails Details,
    required String FileName,
  }) async {
    return _SaveFile(FileName: FileName, Content: ToCsv(Details));
  }

  Future<File> SaveText({
    required EodSummaryDetails Details,
    required String FileName,
  }) async {
    return _SaveFile(FileName: FileName, Content: ToText(Details));
  }

  String ToCsv(EodSummaryDetails Details) {
    final Lines = <String>[
      'Item-Entry,Unit/Measurement,Unit Selling Price/Measurement,SoldUnits,SoldTotal',
    ];

    for (final Line in Details.Lines) {
      Lines.add(
        [
          _Escape(Line.ProductName),
          _Escape(Line.Unit),
          _FormatAmount(Line.UnitPriceInCents),
          Line.SoldUnits,
          _FormatAmount(Line.SoldTotalInCents),
        ].join(','),
      );
    }

    Lines.add(
      [
        'TOTAL',
        '',
        '',
        '',
        _FormatAmount(Details.Summary.TotalSalesInCents),
      ].join(','),
    );

    return Lines.join('\n');
  }

  String ToText(EodSummaryDetails Details) {
    final Lines = <String>[
      'EOD SUMMARY: ${Details.Summary.BusinessDate}',
      'Transactions: ${Details.Summary.TransactionCount}',
      'Sold units: ${Details.Summary.SoldUnitCount}',
      '',
      'Item-Entry | Unit/Measurement | Unit Selling Price/Measurement | SoldUnits | SoldTotal',
    ];

    for (final Line in Details.Lines) {
      Lines.add(
        '${Line.ProductName} | ${Line.Unit} | '
        '${_FormatAmount(Line.UnitPriceInCents)} | ${Line.SoldUnits} | '
        '${_FormatAmount(Line.SoldTotalInCents)}',
      );
    }

    Lines.add('TOTAL: ${_FormatAmount(Details.Summary.TotalSalesInCents)}');
    return Lines.join('\n');
  }

  Future<File> _SaveFile({
    required String FileName,
    required String Content,
  }) async {
    final DocumentsDirectory = await getApplicationDocumentsDirectory();
    final ExportDirectory = Directory(
      '${DocumentsDirectory.path}${Platform.pathSeparator}eod_exports',
    );
    await ExportDirectory.create(recursive: true);

    final FilePath =
        '${ExportDirectory.path}${Platform.pathSeparator}$FileName';
    return File(FilePath).writeAsString(Content);
  }

  String _Escape(String Value) => '"${Value.replaceAll('"', '""')}"';

  String _FormatAmount(int Cents) => (Cents / 100).toStringAsFixed(2);
}
