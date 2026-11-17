# AsKen POS - Next Thread Context

## Source of truth and working rules

- Project root: `D:\AsKen-POS-Flutter\asken_pos`
- Build an offline-first Flutter POS for a small educational-supply business.
- Drift is the source of truth for products, transactions, transaction items, sync batches, and logs.
- Use Flutter Riverpod first for dependency injection and state management.
- Use Riverpod `AsyncNotifier` for asynchronous workflows.
- Use auto-disposal where the feature lifetime is temporary.
- Close database, HTTP, stream, timer, and other resources safely.
- Use PascalCase for variables, methods, fields, parameters, and existing application names.
- Names must be precise, relevant, concise, and non-redundant.
- Keep code modular by feature and responsibility.
- Use dependency injection through Riverpod providers.
- Plan first and request explicit permission before making code changes.
- Prefer efficient, readable, production-oriented implementations.
- Do not delete or reset user data to solve migration or sync problems.

## Current architecture

- Database: `lib/app/core/database/AppDatabase.dart`
- Tables: `Products`, `ProductVariants`, `Transactions`, `TransactionItems`, `TransactionSyncBatches`, `StoreSettings`
- Schema version: `4`
- Generated Drift file: `lib/app/core/database/AppDatabase.g.dart`
- Central providers: `lib/app/core/features/checkout/data/AppProviders.dart`
- Owner feature modules:
  - `application/` for Riverpod notifiers
  - `data/` for database, Drive, export, and sync services
  - `presentation/` for owner pages
- Login controller: `lib/app/core/features/checkout/application/LoginController.dart`
- Login page: `lib/app/core/features/checkout/presentation/Login.dart`

## Database and migration status

- Transactions are stored locally before any remote sync attempt.
- Transaction sync statuses are `pending`, `uploading`, `synced`, and `failed`.
- `Transactions` stores payment method, sync attempt count, last attempt time, synced time, last error, and sync batch ID.
- `TransactionSyncBatches` stores one daily batch per business date, local CSV/TXT paths, checksums, remote file IDs, status, attempt count, errors, and upload time.
- Database migrations are defensive and idempotent.
- Migration checks existing tables and columns before creating or adding them.
- Drift expands acronym column names, for example:
  - `SyncBatchID` -> `sync_batch_i_d`
  - `RemoteTextFileID` -> `remote_text_file_i_d`
- Do not add another schema migration unless the schema actually changes.
- Do not manually edit `AppDatabase.g.dart`; use Drift generation when the environment supports it.

## Local retention policy

`TransactionRetentionService.dart` runs during application initialization.

It deletes transaction items and transactions only when:

```text
SyncStatus == synced
SyncedAt is not null
SyncedAt is older than 30 days
```

Pending, uploading, failed, and recently synced records remain locally. Batch metadata is retained.

## Google Drive configuration

- Google Cloud project: `asken-pos`
- OAuth scope: `https://www.googleapis.com/auth/drive.file`
- Android package: `com.example.asken_pos`
- Web OAuth `serverClientId`: `588343940601-5m912oev3mf1h4m27uhu1b6bprot15o0.apps.googleusercontent.com`
- Android OAuth client is configured in Google Cloud using package name and SHA-1.
- Never hardcode an Android client secret or embed any client secret in the application.
- Designated shared transaction folder ID:
  `124xmqGfTcVs8Dssy4W9_TIas1XIAX0FC`

The designated folder is created in the development Google Drive account and shared with the business owner as Editor. The owner authenticates in the app and the service validates that fixed folder instead of creating a separate folder in the owner account.

Important scope consideration: `drive.file` is intentionally narrow. If owner authentication cannot access the shared folder with the configured scope, do not silently broaden permissions. Review a Google Picker-based folder selection flow first. A full `drive` scope requires security and OAuth review consideration.

## Google Drive implementation completed

- `GoogleDriveService.dart`
  - Initializes `GoogleSignIn.instance`.
  - Uses the configured Web server client ID.
  - Authenticates the selected Google account.
  - Requests `drive.file` authorization.
  - Validates the designated transaction folder ID.
  - Creates and closes the authenticated Google API client safely.
- `GoogleDriveConnectionNotifier.dart`
  - Riverpod auto-dispose async connection state.
  - Connect and disconnect operations.
- `GoogleDriveFileUploadService.dart`
  - Uploads or updates CSV and TXT files.
  - Uses resumable uploads.
  - Uses stored remote file IDs when retrying.
- `TransactionSyncService.dart`
  - Prepares daily local batches.
  - Claims batches before upload.
  - Uploads CSV and TXT files.
  - Saves remote file IDs after each successful file upload.
  - Marks transactions and batches synced only after both files succeed.
  - Marks failed batches and transactions with the error message.
  - Avoids duplicate files after partial uploads.
- `TransactionSyncNotifier.dart`
  - Riverpod async manual sync state.
  - Supports sync-all and individual batch retry.

## Current owner experience

- Owner Dashboard includes:
  - Google Drive connect/disconnect.
  - Sync Transactions action.
  - Open Sync Center action.
- Sync Center shows:
  - Pending batches.
  - Uploading batches.
  - Failed batches.
  - Synced batches.
  - Attempt count.
  - Last attempt time.
  - Last error.
  - Retry individual batch.
  - Sync all pending batches.
- Failed syncs show an owner-facing message and a Retry action.
- The app does not block checkout when sync fails.

## Current sync policy

Manual daily sync is acceptable for the current business scale.

- The owner can sync once per day from Sync Center.
- Data remains locally available when the owner does not sync.
- This does not protect against device loss, device damage, app-data deletion, or database corruption.
- Add a visible pending count and last successful sync reminder before considering background scheduling.
- Do not add a true background scheduler until foreground sync is fully verified.

## Login implementation completed

- One responsive login screen is used for both roles.
- Default path:
  - Cashier name.
  - Start Checkout.
- Explicit owner path:
  - Press Owner Access.
  - Existing owner: enter PIN.
  - First setup: create and confirm PIN.
  - Enter Owner Dashboard.
- The hidden `OWNER` keyword is no longer required for login.
- `LoginController.dart` owns async cashier and owner authentication.
- Login buttons are disabled while authentication or owner PIN configuration is loading.
- Text controllers are disposed correctly.
- Login sizing uses Flutter constraints:
  - `SafeArea`
  - `LayoutBuilder`
  - `SingleChildScrollView`
  - `Center`
  - `ConstrainedBox`
- Do not reintroduce `MediaQuery`-based sizing unless it is specifically needed for a non-layout concern.

## Next checkpoints

1. Run an end-to-end Android verification:
   - Cashier login.
   - First-time owner PIN setup.
   - Existing owner PIN login.
   - Owner Google authentication.
   - Folder validation.
   - CSV/TXT upload.
   - Synced transaction status.
   - Failed upload and retry.
2. Add a clear daily sync status indicator on the Owner Dashboard:
   - Pending count.
   - Last successful sync.
   - Sync recommended message.
3. Add foreground automatic sync on app start/resume only after manual sync is verified.
4. Add password-protected AES ZIP export containing CSV/TXT files for disaster recovery.
5. Add true background scheduling only if the business workflow requires it.
6. Implement thermal printing last, after selecting and testing an ESC/POS Android printer.

## Validation notes

- `flutter pub get` completed successfully after the Google Drive upload dependencies were added.
- `git diff --check` passes; line-ending warnings may appear because the workspace uses mixed CRLF/LF files.
- Dart analyzer and build runner previously hung without output in the local environment; do not treat a hang as a clean validation result.
- Runtime testing on an Android device is still required for Google authentication, shared-folder access, resumable upload behavior, and login sizing.
