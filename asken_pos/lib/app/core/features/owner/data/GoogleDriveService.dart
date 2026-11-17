import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as Drive;
import 'package:googleapis_auth/googleapis_auth.dart' as GoogleApisAuth;

class GoogleDriveService {
  static const String TransactionLogsFolderID =
      '124xmqGfTcVs8Dssy4W9_TIas1XIAX0FC';
  static const String FolderMimeType = 'application/vnd.google-apps.folder';
  static const String WebServerClientID =
      '588343940601-5m912oev3mf1h4m27uhu1b6bprot15o0.apps.googleusercontent.com';
  static const String DriveFileScope =
      'https://www.googleapis.com/auth/drive.file';
  static const List<String> Scopes = <String>[DriveFileScope];

  final GoogleSignIn SignIn;
  GoogleApisAuth.AuthClient? _AuthClient;
  bool _IsInitialized = false;

  GoogleDriveService({GoogleSignIn? SignIn})
    : SignIn = SignIn ?? GoogleSignIn.instance;

  Future<GoogleDriveConnection> Connect() async {
    await _Initialize();

    final GoogleSignInAccount Account = await SignIn.authenticate();
    final GoogleSignInClientAuthorization Authorization =
        await _Authorize(Account);

    await _CloseAuthClient();
    _AuthClient = Authorization.authClient(scopes: Scopes);
    await ValidateTransactionLogsFolder();

    return GoogleDriveConnection(
      Email: Account.email,
      DisplayName: Account.displayName,
      TransactionLogsFolderID: GoogleDriveService.TransactionLogsFolderID,
    );
  }

  Future<void> ValidateTransactionLogsFolder() async {
    final Drive.DriveApi DriveAPI = GetDriveAPI();
    final Object Metadata = await DriveAPI.files.get(
      TransactionLogsFolderID,
      $fields: 'id,name,mimeType,trashed',
    );

    if (Metadata is! Drive.File ||
        Metadata.id != TransactionLogsFolderID ||
        Metadata.mimeType != FolderMimeType ||
        Metadata.trashed == true) {
      throw StateError(
        'The configured Google Drive transaction folder is unavailable.',
      );
    }
  }

  Drive.DriveApi GetDriveAPI() {
    final GoogleApisAuth.AuthClient? AuthClient = _AuthClient;

    if (AuthClient == null) {
      throw StateError('Google Drive is not connected.');
    }

    return Drive.DriveApi(AuthClient);
  }

  Future<void> Disconnect() async {
    await _CloseAuthClient();
    await SignIn.disconnect();
  }

  Future<void> Dispose() async {
    await _CloseAuthClient();
  }

  Future<void> _Initialize() async {
    if (_IsInitialized) {
      return;
    }

    await SignIn.initialize(serverClientId: WebServerClientID);
    _IsInitialized = true;
  }

  Future<GoogleSignInClientAuthorization> _Authorize(
    GoogleSignInAccount Account,
  ) async {
    final GoogleSignInClientAuthorization? ExistingAuthorization =
        await Account.authorizationClient.authorizationForScopes(Scopes);

    return ExistingAuthorization ??
        await Account.authorizationClient.authorizeScopes(Scopes);
  }

  Future<void> _CloseAuthClient() async {
    final GoogleApisAuth.AuthClient? AuthClient = _AuthClient;
    _AuthClient = null;
    AuthClient?.close();
  }

}

class GoogleDriveConnection {
  final String Email;
  final String? DisplayName;
  final String TransactionLogsFolderID;

  const GoogleDriveConnection({
    required this.Email,
    this.DisplayName,
    required this.TransactionLogsFolderID,
  });
}
