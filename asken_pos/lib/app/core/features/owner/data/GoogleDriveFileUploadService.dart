import 'dart:io';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as Commons;
import 'package:googleapis/drive/v3.dart' as Drive;
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveService.dart';

class GoogleDriveFileUploadService {
  final GoogleDriveService DriveService;

  const GoogleDriveFileUploadService({required this.DriveService});

  Future<Drive.File> UploadOrUpdate({
    required File LocalFile,
    required String FileName,
    required String ContentType,
    required String ParentFolderID,
    String? RemoteFileID,
  }) async {
    final Drive.DriveApi DriveAPI = DriveService.GetDriveAPI();
    final int FileLength = await LocalFile.length();
    final Media = Commons.Media(
      LocalFile.openRead(),
      FileLength,
      contentType: ContentType,
    );
    final Metadata = Drive.File(
      name: FileName,
      parents: RemoteFileID == null
          ? <String>[ParentFolderID]
          : null,
    );

    if (RemoteFileID == null) {
      return DriveAPI.files.create(
        Metadata,
        uploadMedia: Media,
        uploadOptions: Commons.UploadOptions.resumable,
        supportsAllDrives: true,
        $fields: 'id,name,mimeType,parents',
      );
    }

    return DriveAPI.files.update(
      Metadata,
      RemoteFileID,
      uploadMedia: Media,
      uploadOptions: Commons.UploadOptions.resumable,
      supportsAllDrives: true,
      $fields: 'id,name,mimeType,parents',
    );
  }
}
