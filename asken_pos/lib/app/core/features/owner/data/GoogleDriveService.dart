import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as Drive;
import 'package:googleapis_auth/googleapis_auth.dart' as GoogleApisAuth;
import 'package:asken_pos/app/core/features/owner/data/CloudSyncSettingsService.dart';
import 'package:asken_pos/app/core/features/printing/data/StoreSettingsService.dart';

class GoogleDriveService {
  static const String FolderMimeType = 'application/vnd.google-apps.folder';
  static const String RootFolderType = 'root';
  static const String TransactionLogsFolderType = 'transaction_logs';
  static const String EodLogsFolderType = 'eod_logs';
  static const String ApplicationPropertyKey = 'AsKenPOS';
  static const String InstallationPropertyKey = 'InstallationID';
  static const String FolderTypePropertyKey = 'FolderType';
  static const String RootFolderName = 'AsKen POS';
  static const String TransactionLogsFolderName = 'Transaction Logs';
  static const String EodLogsFolderName = 'EOD Logs';
  static const String WebServerClientID =
      '588343940601-5m912oev3mf1h4m27uhu1b6bprot15o0.apps.googleusercontent.com';
  static const String DriveFileScope =
      'https://www.googleapis.com/auth/drive.file';
  static const List<String> Scopes = <String>[DriveFileScope];

  final GoogleSignIn SignIn;
  final CloudSyncSettingsService SettingsService;
  final StoreSettingsService StoreSettings;
  GoogleApisAuth.AuthClient? _AuthClient;
  bool _IsInitialized = false;

  GoogleDriveService({
    GoogleSignIn? SignIn,
    required this.SettingsService,
    required this.StoreSettings,
  })
    : SignIn = SignIn ?? GoogleSignIn.instance;

  Future<GoogleDriveConnection> Connect() async {
    await _Initialize();

    final GoogleSignInAccount Account = await SignIn.authenticate();
    final GoogleSignInClientAuthorization Authorization =
        await _Authorize(Account);

    await _CloseAuthClient();
    _AuthClient = Authorization.authClient(scopes: Scopes);

    try {
      final Settings = await SettingsService.GetSettings();
      final CanReuseFolders =
          Settings.IsAppOwned &&
          Settings.ProvisioningStatus ==
              CloudSyncSettingsService.ProvisionedStatus &&
          Settings.TransactionLogsFolderID.isNotEmpty &&
          Settings.EodLogsFolderID.isNotEmpty &&
          (Settings.FolderOwnerEmail == null ||
              Settings.FolderOwnerEmail == Account.email);

      if (CanReuseFolders) {
        try {
          await ValidateConfiguredFolders(
            TransactionLogsFolderID: Settings.TransactionLogsFolderID,
            EodLogsFolderID: Settings.EodLogsFolderID,
            InstallationID: Settings.InstallationID,
          );
          await SettingsService.MarkValidated(
            FolderOwnerEmail: Account.email,
          );
        } on StateError {
          await ProvisionBusinessFolders(Account: Account);
        }
      } else {
        await ProvisionBusinessFolders(Account: Account);
      }

      final ProvisionedSettings = await SettingsService.GetSettings();

      return GoogleDriveConnection(
        Email: Account.email,
        DisplayName: Account.displayName,
        TransactionLogsFolderID: ProvisionedSettings.TransactionLogsFolderID,
        EodLogsFolderID: ProvisionedSettings.EodLogsFolderID,
      );
    } catch (CaughtError, StackTrace) {
      await _CloseAuthClient();
      Error.throwWithStackTrace(CaughtError, StackTrace);
    }
  }

  Future<void> ValidateConfiguredFolders({
    required String TransactionLogsFolderID,
    required String EodLogsFolderID,
    required String InstallationID,
  }) async {
    await _ValidateFolder(
      FolderID: TransactionLogsFolderID,
      Description: 'transaction logs',
      InstallationID: InstallationID,
      FolderType: TransactionLogsFolderType,
    );
    await _ValidateFolder(
      FolderID: EodLogsFolderID,
      Description: 'EOD logs',
      InstallationID: InstallationID,
      FolderType: EodLogsFolderType,
    );
  }

  Future<void> _ValidateFolder({
    required String FolderID,
    required String Description,
    required String InstallationID,
    required String FolderType,
  }) async {
    final Drive.DriveApi DriveAPI = GetDriveAPI();
    late Object Metadata;

    try {
      Metadata = await DriveAPI.files.get(
        FolderID,
        $fields: 'id,name,mimeType,trashed,appProperties',
        supportsAllDrives: true,
      );
    } catch (CaughtError) {
      final ErrorMessage = CaughtError.toString();
      if (ErrorMessage.contains('File not found') ||
          ErrorMessage.contains('404')) {
        throw StateError(
          'Google Drive cannot access the configured $Description folder. '
          'Verify the folder ID and confirm that the connected Google account '
          'can access it through this app.',
        );
      }

      rethrow;
    }

    if (Metadata is! Drive.File ||
        Metadata.id != FolderID ||
        Metadata.mimeType != FolderMimeType ||
        Metadata.trashed == true ||
        !_HasExpectedProperties(
          Metadata,
          InstallationID: InstallationID,
          FolderType: FolderType,
        )) {
      throw StateError(
        'The configured Google Drive $Description folder is not an AsKen POS app-owned folder.',
      );
    }
  }

  Future<void> ProvisionBusinessFolders({
    required GoogleSignInAccount Account,
  }) async {
    final ExistingSettings = await SettingsService.GetSettings();
    final IsResuming =
        ExistingSettings.ProvisioningStatus ==
        CloudSyncSettingsService.ProvisioningStatus;

    if (!IsResuming) {
      await SettingsService.BeginProvisioning();
    }

    final Settings = await SettingsService.GetSettings();
    final Store = await StoreSettings.GetSettings();
    final BusinessName = Store.StoreName.trim().isEmpty
        ? 'Business'
        : Store.StoreName.trim();

    try {
      final RootFolderID = await _GetOrCreateFolder(
        FolderName: '$RootFolderName - $BusinessName',
        FolderType: RootFolderType,
        InstallationID: Settings.InstallationID,
        ExistingFolderID: Settings.RootFolderID,
      );
      await SettingsService.SaveProvisioningProgress(
        RootFolderID: RootFolderID,
      );

      final TransactionFolderID = await _GetOrCreateFolder(
        FolderName: TransactionLogsFolderName,
        FolderType: TransactionLogsFolderType,
        InstallationID: Settings.InstallationID,
        ParentFolderID: RootFolderID,
        ExistingFolderID: Settings.TransactionLogsFolderID,
      );
      await SettingsService.SaveProvisioningProgress(
        RootFolderID: RootFolderID,
        TransactionLogsFolderID: TransactionFolderID,
      );

      final EodFolderID = await _GetOrCreateFolder(
        FolderName: EodLogsFolderName,
        FolderType: EodLogsFolderType,
        InstallationID: Settings.InstallationID,
        ParentFolderID: RootFolderID,
        ExistingFolderID: Settings.EodLogsFolderID,
      );

      await SettingsService.SaveProvisionedFolders(
        RootFolderID: RootFolderID,
        TransactionLogsFolderID: TransactionFolderID,
        EodLogsFolderID: EodFolderID,
        FolderOwnerEmail: Account.email,
      );
    } catch (CaughtError, StackTrace) {
      await SettingsService.MarkProvisioningFailed();
      Error.throwWithStackTrace(CaughtError, StackTrace);
    }
  }

  Future<String> _GetOrCreateFolder({
    required String FolderName,
    required String FolderType,
    required String InstallationID,
    String? ParentFolderID,
    String? ExistingFolderID,
  }) async {
    final ExistingFolder = await _ReadAppOwnedFolder(
      FolderID: ExistingFolderID,
      InstallationID: InstallationID,
      FolderType: FolderType,
    );
    if (ExistingFolder?.id != null && ExistingFolder!.id!.isNotEmpty) {
      return ExistingFolder.id!;
    }

    final DiscoveredFolder = await _FindAppOwnedFolder(
      InstallationID: InstallationID,
      FolderType: FolderType,
      ParentFolderID: ParentFolderID,
    );
    if (DiscoveredFolder != null) {
      return DiscoveredFolder;
    }

    final Drive.DriveApi DriveAPI = GetDriveAPI();
    final Metadata = Drive.File(
      name: FolderName,
      mimeType: FolderMimeType,
      parents: ParentFolderID == null ? null : <String>[ParentFolderID],
      appProperties: <String, String>{
        ApplicationPropertyKey: 'true',
        InstallationPropertyKey: InstallationID,
        FolderTypePropertyKey: FolderType,
      },
    );
    final Drive.File CreatedFolder = await DriveAPI.files.create(
      Metadata,
      supportsAllDrives: true,
      $fields: 'id,name,mimeType,trashed,parents,appProperties',
    );
    final String? CreatedFolderID = CreatedFolder.id;
    if (CreatedFolderID == null || CreatedFolderID.isEmpty) {
      throw StateError(
        'Google Drive created the $FolderType folder without returning an ID.',
      );
    }

    return CreatedFolderID;
  }

  Future<Drive.File?> _ReadAppOwnedFolder({
    required String? FolderID,
    required String InstallationID,
    required String FolderType,
  }) async {
    if (FolderID == null || FolderID.isEmpty) {
      return null;
    }

    final Drive.DriveApi DriveAPI = GetDriveAPI();

    try {
      final Object Metadata = await DriveAPI.files.get(
        FolderID,
        $fields: 'id,name,mimeType,trashed,parents,appProperties',
        supportsAllDrives: true,
      );
      if (Metadata is! Drive.File ||
          Metadata.id != FolderID ||
          !_HasExpectedProperties(
            Metadata,
            InstallationID: InstallationID,
            FolderType: FolderType,
          )) {
        return null;
      }

      return Metadata;
    } catch (CaughtError) {
      if (_IsNotFoundError(CaughtError)) {
        return null;
      }

      rethrow;
    }
  }

  Future<String?> _FindAppOwnedFolder({
    required String InstallationID,
    required String FolderType,
    String? ParentFolderID,
  }) async {
    final Drive.DriveApi DriveAPI = GetDriveAPI();
    final ParentClause = ParentFolderID == null
        ? ''
        : " and '$ParentFolderID' in parents";
    final Query =
        "trashed = false and appProperties has { key = '$ApplicationPropertyKey' and value = 'true' } and appProperties has { key = '$InstallationPropertyKey' and value = '$InstallationID' } and appProperties has { key = '$FolderTypePropertyKey' and value = '$FolderType' }$ParentClause";
    final Drive.FileList Result = await DriveAPI.files.list(
      q: Query,
      spaces: 'drive',
      pageSize: 10,
      orderBy: 'createdTime',
      includeItemsFromAllDrives: true,
      supportsAllDrives: true,
      $fields: 'files(id,name,mimeType,trashed,parents,appProperties)',
    );
    final Files = Result.files ?? const <Drive.File>[];
    if (Files.isEmpty) {
      return null;
    }
    if (Files.length > 1) {
      throw StateError(
        'Multiple app-owned $FolderType folders were found for this installation.',
      );
    }

    return Files.first.id;
  }

  bool _HasExpectedProperties(
    Drive.File Folder, {
    required String InstallationID,
    required String FolderType,
  }) {
    final Properties = Folder.appProperties;
    return Properties?[ApplicationPropertyKey] == 'true' &&
        Properties?[InstallationPropertyKey] == InstallationID &&
        Properties?[FolderTypePropertyKey] == FolderType &&
        Folder.mimeType == FolderMimeType &&
        Folder.trashed != true;
  }

  bool _IsNotFoundError(Object Error) {
    final ErrorMessage = Error.toString();
    return ErrorMessage.contains('File not found') ||
        ErrorMessage.contains('404');
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
  final String EodLogsFolderID;

  const GoogleDriveConnection({
    required this.Email,
    this.DisplayName,
    required this.TransactionLogsFolderID,
    required this.EodLogsFolderID,
  });
}
