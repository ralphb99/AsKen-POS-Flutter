import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/owner/data/UpdateAppProtocolSnapshotService.dart';
import 'package:asken_pos/app/core/features/owner/domain/UpdateAppProtocol.dart';

class UpdateAppProtocolExportService {
  static const String ProtocolName = 'AsKenPOS.UpdateAppProtocol';
  static const int ProtocolVersion = 1;
  static const String FileExtension = '.askenbackup';

  final AppDatabase Database;
  final UpdateAppProtocolSnapshotService SnapshotService;

  const UpdateAppProtocolExportService({
    required this.Database,
    required this.SnapshotService,
  });

  Future<UpdateAppProtocolExportResult?> Export() async {
    final CreatedAtUtc = DateTime.now().toUtc();
    final Snapshot = await SnapshotService.CreateSnapshot();
    final DataPayload = Snapshot.ToDataPayload();
    final DataJson = jsonEncode(DataPayload);
    final DataChecksumSHA256 = sha256.convert(utf8.encode(DataJson)).toString();
    final Document = <String, dynamic>{
      'Manifest': <String, dynamic>{
        'ProtocolName': ProtocolName,
        'ProtocolVersion': ProtocolVersion,
        'DatabaseSchemaVersion': Database.schemaVersion,
        'CreatedAtUtc': CreatedAtUtc.toIso8601String(),
        'DataEncoding': 'UTF-8 JSON',
        'DataChecksumAlgorithm': 'SHA-256',
        'DataChecksumSHA256': DataChecksumSHA256,
        'Counts': Snapshot.GetCounts(),
        'ExcludedDeviceSpecificFields': <String>[
          'LocalFilePath',
          'TextLocalFilePath',
        ],
      },
      'Data': DataPayload,
    };
    final DocumentJson = const JsonEncoder.withIndent('  ').convert(Document);
    final DocumentBytes = Uint8List.fromList(utf8.encode(DocumentJson));
    final FileName = _CreateFileName(CreatedAtUtc);
    final SavedUri = await FilePicker.saveFile(
      fileName: FileName,
      bytes: DocumentBytes,
      mimeType: 'application/json',
      dialogTitle: 'Save AsKen POS update backup',
    );

    if (SavedUri == null) {
      return null;
    }

    return UpdateAppProtocolExportResult(
      FileName: FileName,
      SavedLocation: SavedUri.toString(),
      FileSizeInBytes: DocumentBytes.length,
      DataChecksumSHA256: DataChecksumSHA256,
      CreatedAtUtc: CreatedAtUtc,
      Counts: Snapshot.GetCounts(),
    );
  }

  String _CreateFileName(DateTime CreatedAtUtc) {
    final Year = CreatedAtUtc.year.toString().padLeft(4, '0');
    final Month = CreatedAtUtc.month.toString().padLeft(2, '0');
    final Day = CreatedAtUtc.day.toString().padLeft(2, '0');
    final Hour = CreatedAtUtc.hour.toString().padLeft(2, '0');
    final Minute = CreatedAtUtc.minute.toString().padLeft(2, '0');
    final Second = CreatedAtUtc.second.toString().padLeft(2, '0');

    return 'AsKenPOS_UpdateBackup_${Year}${Month}${Day}_${Hour}${Minute}${Second}$FileExtension';
  }
}
