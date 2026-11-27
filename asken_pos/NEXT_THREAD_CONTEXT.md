# AsKen POS - Next Thread Context

## Source of truth and working rules

- Project root: `D:\AsKen-POS-Flutter\asken_pos`
- Build an offline-first Flutter POS for a small educational-supply business.
- Drift is the source of truth for products, transactions, transaction items, EOD summaries, sync batches, cloud-folder configuration, and logs.
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
- Tables: `Products`, `ProductVariants`, `Transactions`, `TransactionItems`, `TransactionPrintJobs`, `TransactionSyncBatches`, `EodSummaries`, `EodSummaryItems`, `StoreSettings`, `CloudSyncSettings`
- Schema version: `9`
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
- Every saved transaction creates one durable `TransactionPrintJobs` row in the same database transaction.
- Print job statuses are `pending`, `printing`, `printed`, and `failed`.
- Print jobs store attempt count, last attempt time, printed time, and the last printer error.
- Print jobs cascade when their retained transaction is deleted.
- Transaction sync statuses are `pending`, `uploading`, `synced`, and `failed`.
- `Transactions` stores payment method, sync attempt count, last attempt time, synced time, last error, and sync batch ID.
- `TransactionSyncBatches` stores one daily batch per business date, local CSV/TXT paths, checksums, remote file IDs, status, attempt count, errors, and upload time.
- `EodSummaries` stores one daily summary per business date and `EodSummaryItems` aggregates repeated sales by product variant, product snapshot, unit snapshot, and unit price.
- `CloudSyncSettings` stores the app-owned root, transaction-log, and EOD-log Google Drive folder IDs, installation identity, provisioning state, owner account, and last validation time for this isolated business installation.
- Each `TransactionSyncBatches` row snapshots `TransactionLogsFolderID` and `EodLogsFolderID` so a folder reconfiguration cannot split one partially uploaded batch across destinations.
- Database migrations are defensive and idempotent.
- Migration checks existing tables and columns before creating or adding them.
- Drift expands acronym column names, for example:
  - `SyncBatchID` -> `sync_batch_i_d`
  - `RemoteTextFileID` -> `remote_text_file_i_d`
- `TransactionLogsFolderID` -> `transaction_logs_folder_i_d`
- `EodLogsFolderID` -> `eod_logs_folder_i_d`
- `RootFolderID` -> `root_folder_i_d`
- `InstallationID` -> `installation_i_d`
- Do not add another schema migration unless the schema actually changes.
- Do not manually edit `AppDatabase.g.dart`; use Drift generation when the environment supports it.

## Local retention policy

`TransactionRetentionService.dart` runs during application initialization.

It deletes transaction items and transactions only when:

```text
SyncStatus == synced
SyncedAt is not null
SyncedAt is older than 30 days
Print job is printed, or no print job exists for a legacy transaction
```

Pending, uploading, failed, recently synced, and not-yet-printed records remain locally. Batch metadata is retained.

## Google Drive configuration

- Google Cloud project: `asken-pos`
- OAuth scope: `https://www.googleapis.com/auth/drive.file`
- Android package: `com.example.asken_pos`
- Web OAuth `serverClientId`: `588343940601-5m912oev3mf1h4m27uhu1b6bprot15o0.apps.googleusercontent.com`
- Android OAuth client is configured in Google Cloud using package name and SHA-1.
- Never hardcode an Android client secret or embed any client secret in the application.
- Folder IDs are not hard-coded as business configuration. On first connection, the app creates an `AsKen POS - <Business Name>` root folder with `Transaction Logs` and `EOD Logs` child folders in the authenticated business account.
- The app stores the generated IDs in `CloudSyncSettings` and reuses them on later connections.
- Existing manually-created folders, including the previous transaction and EOD folder IDs, are not deleted or overwritten and remain available as archives.
- Folder metadata contains an app marker, installation ID, and folder type so provisioning can discover and resume app-owned folders without creating duplicates.
- Transaction CSV/TXT files upload only to `TransactionLogsFolderID`.
- EOD CSV/TXT files upload only to `EodLogsFolderID`.
- New sync batches use the provisioned destinations; existing batches retain their snapshotted destinations.

Important scope consideration: `drive.file` is intentionally narrow. If owner authentication cannot access the shared folder with the configured scope, do not silently broaden permissions. Review a Google Picker-based folder selection flow first. A full `drive` scope requires security and OAuth review consideration.

Current troubleshooting note: Google Drive may return `File not found`/404 when a pre-existing folder exists but the connected account or app cannot read it. The app now provisions its own folders under the authenticated account and sends `supportsAllDrives: true` for validation, creation, and uploads. This avoids requiring Picker or a broad `drive` scope for normal setup.

## Google Drive implementation completed

- `GoogleDriveService.dart`
  - Initializes `GoogleSignIn.instance`.
  - Uses the configured Web server client ID.
  - Authenticates the selected Google account.
  - Requests `drive.file` authorization.
  - Reads provisioning state through `CloudSyncSettingsService`.
  - Creates or resumes the app-owned root, transaction-log, and EOD-log folders on first connection.
  - Stores app properties for installation ID and folder type to make provisioning idempotent.
  - Validates both app-owned folders before reporting a successful connection.
  - Creates and closes the authenticated Google API client safely.
- `GoogleDriveConnectionNotifier.dart`
  - Riverpod auto-dispose async connection state.
  - Connect and disconnect operations.
- `GoogleDriveFileUploadService.dart`
  - Uploads or updates CSV and TXT files.
  - Receives the destination parent folder ID per upload.
  - Uses resumable uploads.
  - Uses stored remote file IDs when retrying.
- `TransactionSyncService.dart`
  - Prepares daily local batches.
  - Claims batches before upload.
  - Uploads transaction CSV/TXT files to the transaction folder.
  - Uploads EOD CSV/TXT files to the separate EOD folder.
  - Saves remote file IDs after each successful file upload.
  - Marks transactions and batches synced only after both files succeed.
  - Marks failed batches and transactions with the error message.
  - Avoids duplicate files after partial uploads.
- `TransactionSyncNotifier.dart`
  - Riverpod async manual sync state.
  - Supports sync-all and individual batch retry.
- `CloudSyncSettingsService.dart` and `CloudSyncSettingsNotifier.dart`
  - Persist provisioning state, installation identity, generated folder IDs, and validation metadata.
  - Use Riverpod `AsyncNotifier` for cloud-folder setup state.
- `CloudSyncSettings.dart`
  - Owner-only read-only setup/status page; folder IDs are generated by the app rather than entered manually.

## Current owner experience

- Owner Dashboard includes:
  - Google Drive connect/disconnect.
  - Today-only EOD dashboard metrics: transaction count, sold units, total sales, and distinct cashier names.
  - EOD Summary records, date filtering, detail view, and CSV/TXT export.
  - Sync Transactions and EOD action.
  - Open Sync Center action.
  - Owner Settings and Cloud Folder Setup.
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
- Clearing an unsaved checkout only clears the current session and never creates an EOD entry.

## Reusable business-installation model

- The same application binary/codebase is reused by different businesses.
- Each business installation has its own isolated Drift database and cloud-folder configuration.
- No `BusinessID` is required on transaction, product, or EOD records for this deployment model.
- Business identity is represented by persisted store settings, receipt/export naming configuration, and the configured cloud folders.
- Technical identifiers such as the SQLite database name, table names, package ID, OAuth client ID, and Drive scopes remain application-level configuration.

## EOD module implementation

- A completed sale records its EOD summary inside the same Drift transaction as the transaction, transaction items, and print job.
- EOD summaries are created only for confirmed/completed sales.
- Repeated sales of the same product variant, product snapshot, unit snapshot, and unit price aggregate into one EOD line.
- Unsaved checkout clearing does not create or alter EOD data.
- Owner Dashboard shows today-only EOD metrics.
- Owner EOD Summary supports date filtering, detailed views, cashier names, CSV/TXT export, and offline persistence.
- Existing transactions are backfilled into EOD summaries during initialization when required.

## Thermal printing foundation

The first printing checkpoint is implemented without binding the app to an unconfirmed printer model:

- `TransactionService.dart` saves the transaction, line items, and pending print job atomically.
- `ReceiptDataService.dart` rebuilds a receipt from persisted transaction data and the current store settings.
- `TransactionPrintJobService.dart` claims, retries, completes, fails, and recovers interrupted print jobs.
- `TransactionPrintService.dart` separates database print state from the hardware adapter and limits a print attempt to eight seconds.
- `ThermalPrinterService.dart` defines the hardware boundary and currently provides a placeholder adapter that reports no configured printer.
- `TransactionPrintNotifier.dart` exposes retry/reprint operations through Riverpod `AsyncNotifier`.
- Checkout immediately returns to the cashier flow after the transaction is saved. Failed or pending printing appears as a retry panel and does not block new sales.
- Owner Transaction Details includes Retry Print/Reprint Receipt.
- Owner Settings now seeds and edits the initial receipt placeholders:
  - `Educational Supply Store`
  - `Address not configured`
  - `Contact number not configured`
  - `Thank you for your purchase.`
- The transaction preview and the future hardware printer use the same persisted store settings.
- No thermal-printer package or Bluetooth/USB permission has been selected yet. The adapter must wait for the owner’s printer model and transport type.

## Update App Protocol implementation status

The first export checkpoint is implemented as an owner-only flow:

- `UpdateAppProtocolPage.dart` is available from the Owner Dashboard.
- `UpdateAppProtocolNotifier.dart` owns the asynchronous export state through Riverpod.
- `UpdateAppProtocolSnapshotService.dart` reads a consistent Drift snapshot of:
  - Products.
  - Product variants.
  - Transactions, including pending, failed, uploading, and synced status fields.
  - Transaction items.
  - Transaction sync batches, including retry metadata, remote file IDs, and checksums.
  - EOD summaries and aggregated EOD summary items.
  - Store settings.
  - Cloud sync folder settings and per-batch destination folder snapshots.
- `UpdateAppProtocolExportService.dart` writes a readable UTF-8 JSON document with an `.askenbackup` extension through the native file save dialog.
- The manifest contains the protocol version, database schema version, record counts, UTC creation time, and a SHA-256 checksum of the data payload.
- Device-specific local CSV/TXT paths are intentionally excluded. The future importer can regenerate those files from the preserved transaction data.
- Remote folder IDs are preserved as configuration and batch metadata; OAuth tokens and authenticated clients are never stored in Drift backups.
- The export/import protocol remains backward-compatible and does not encrypt the backup yet.
- The backup protocol now also preserves `TransactionPrintJobs` when present. Older backups without that optional collection remain readable.
- The owner is instructed to verify the file exists before installing a replacement APK.

The import and restore-preview checkpoint is now implemented:

- `UpdateAppProtocolImportService.dart` opens and validates `.askenbackup` files.
- Validation checks the protocol name/version, supported database schema version, required collections, manifest counts, SHA-256 data checksum, record types, duplicate IDs/keys, foreign-key relationships, dates, and sync statuses.
- `UpdateAppProtocolImportNotifier.dart` exposes file selection, preview, and restore state through Riverpod `AsyncNotifier`.
- The owner page shows incoming record counts, unsynced transaction count, and existing/conflicting records before restore.
- Restore runs inside one Drift transaction and inserts only non-conflicting records.
- Existing records are never overwritten or deleted. Conflicting records and dependent transaction items are skipped and reported.
- Device-specific local CSV/TXT paths remain excluded; the updated app can regenerate those files from the restored records.

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

0. Verify the per-business cloud-folder setup on Android:
   - Connect a new business Google account.
   - Confirm the app creates one root folder with separate Transaction Logs and EOD Logs children.
   - Confirm generated folder IDs and app-owned provisioning state load from Drift.
   - Disconnect/reconnect and confirm no duplicate folders are created.
   - Confirm transaction files upload only to the transaction folder.
   - Confirm EOD files upload only to the EOD folder.
   - Delete or revoke access to an app-owned folder and verify the repair path reports the failure safely.
1. Run an end-to-end Android verification of the Update App Protocol export and restore:
   - Enter Owner Mode.
   - Open Prepare App Update Backup.
   - Export a backup to a user-selected location.
   - Confirm the file has the `.askenbackup` extension and opens as readable JSON.
   - Confirm the manifest counts and checksum are present.
   - Pick the exported file again.
   - Confirm the preview counts and conflict count.
   - Confirm a valid backup restores without overwriting existing records.
   - Confirm a damaged or modified backup is rejected before database writes.
2. Add explicit conflict-resolution options if the owner needs to replace changed seeded/catalog records after reviewing the conflict list. Keep insert-only restore as the default.
3. Add password-protected encryption after the plain protocol/import contract is verified. Keep the manifest available for validation without exposing sensitive data.
4. Continue the existing operational verification:
   - Cashier login.
   - First-time owner PIN setup.
   - Existing owner PIN login.
   - Owner Google authentication.
   - Folder validation.
   - CSV/TXT upload.
   - Synced transaction status.
   - Failed upload and retry.
6. Add a clear daily sync status indicator on the Owner Dashboard:
   - Pending count.
   - Last successful sync.
   - Sync recommended message.
7. Add foreground automatic sync on app start/resume only after manual sync is verified.
8. Add true background scheduling only if the business workflow requires it.
9. Verify the transaction print-state flow on Android with the placeholder adapter:
   - Confirming a sale saves the transaction and print job atomically.
   - Confirming a sale returns the cashier to checkout even when printing fails.
   - Retry Print appears on checkout.
   - Retry Print/Reprint Receipt works from Owner Transaction Details.
   - Interrupted `printing` jobs recover as failed after app restart.
9. Select the owner’s thermal printer model and transport type, then implement and test the ESC/POS adapter behind `ThermalPrinterService`.

## Validation notes

- `flutter pub get` completed successfully after the Google Drive upload dependencies were added.
- Direct Dart SDK analysis of `lib` and `test` completes with no errors after the cloud-folder implementation. The repository continues to emit existing PascalCase and file-name informational lints.
- Drift generation completed with the direct Dart SDK and regenerated `AppDatabase.g.dart` for schema version 9.
- `git diff --check` passes; line-ending warnings may appear because the workspace uses mixed CRLF/LF files.
- `flutter test test/eod_summary_test.dart` passes all four focused tests, including unprovisioned cloud settings and separate transaction/EOD batch destinations.
- Full widget-test validation still needs the pre-existing `test/widget_test.dart` fixture reviewed; its `main` function is fully commented out.
- The `dart` command wrapper can hang without output in this environment; use `D:\DevTools\flutter\bin\cache\dart-sdk\bin\dart.exe` for bounded analyzer and Drift-generation checks.
- Runtime testing on an Android device is still required for Google authentication, shared-folder access, resumable upload behavior, login sizing, native backup saving/import, print-job recovery, and the eventual thermal-printer adapter.
