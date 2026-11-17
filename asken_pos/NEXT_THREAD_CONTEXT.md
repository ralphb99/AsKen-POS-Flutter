# AsKen POS — Next Thread Context

## Project rules

- Build an offline-first Flutter POS for a small educational-supply business.
- No inventory management yet.
- Drift is the source of truth for products, variants, transactions, and logs.
- Use Riverpod for dependency injection and state management.
- Preserve the existing PascalCase/AppDatabase naming convention.
- Plan first and never change code without explicit permission.
- Prefer efficient, readable, non-redundant production code.

## Current architecture

- Flutter project: `D:\AsKen-POS-Flutter\asken_pos`
- Database: `lib/app/core/database/AppDatabase.dart`
- Tables: `Products`, `ProductVariants`, `Transactions`, `TransactionItems`, `TransactionSyncBatches`, `StoreSettings`
- Database schema version: `4`
- Generated Drift file: `lib/app/core/database/AppDatabase.g.dart`
- Providers: `lib/app/core/features/checkout/data/AppProviders.dart`
- Owner transaction records/export: `lib/app/core/features/owner/data/TransactionRecordsService.dart`

## Offline transaction logging

`Transactions` contains:

- `PaymentMethod` — currently cash by default
- `SyncStatus` — pending/uploading/synced/failed
- `SyncAttemptCount`
- `LastSyncAttemptAt`
- `SyncedAt`
- `LastSyncError`
- `SyncBatchID`

Transactions and items are saved locally before any upload attempt.

## Local sync implementation completed

- `TransactionSyncBatches` stores one daily batch per business date.
- `TransactionSyncBatchService.dart` supports daily batch creation/retrieval, unsynced-date discovery, upload claiming, success/failure updates, interrupted-upload recovery, and CSV/TXT metadata.
- `TransactionSyncOrchestrator.dart` finds pending dates, generates daily CSV/TXT files, saves them locally, calculates SHA-256 checksums, and records paths/checksums/counts.
- Google Drive upload is not connected yet.
- Preparation does not mark transactions as synced.

Local exports are stored under the app documents directory in `transaction_exports`.

## Retention policy

`TransactionRetentionService.dart` runs during startup initialization.

It deletes transaction items and transactions only when:

```text
SyncStatus == synced
SyncedAt is not null
SyncedAt is older than 30 days
```

Unsynced, failed, pending, and recently synced logs remain in Drift. Batch metadata is retained. A true OS background scheduler can be added later.

## Google Drive configuration

- Google Cloud project ID: `asken-pos`
- OAuth scope: `https://www.googleapis.com/auth/drive.file`
- Android package: `com.example.asken_pos`
- Web OAuth client ID (`serverClientId`): `588343940601-5m912oev3mf1h4m27uhu1b6bprot15o0.apps.googleusercontent.com`
- Android OAuth client ID is registered in Google Cloud with the package name and SHA-1. It should not be hardcoded in Dart.
- Never add or embed a client secret in the APK.

The user owns the development Google Drive and will share the folder with the business owners. Production ownership should eventually move to the business owner’s Google account.

## Dependencies already added

```yaml
google_sign_in: ^7.2.0
googleapis: ^19.0.0
extension_google_sign_in_as_googleapis_auth: ^3.0.0
http: ^1.6.0
```

The bridge package is required for creating an authenticated `googleapis` client in Flutter.

## Android permissions

- `INTERNET` is present in the main Android manifest for future sync.
- No storage permission is required for app-specific exports.
- No Bluetooth permissions are added yet; add them only when the thermal-printer package is selected.

## Billing note

- The Google Cloud `$300` trial is optional, finite, valid for 90 days, and not renewable.
- It does not automatically charge unless the account is manually upgraded.
- Standard low-volume Drive API usage has no additional cost within normal quotas.
- A normal Google account provides up to 15 GB shared Drive/Gmail/Photos storage.
- If Google requires billing before proceeding, stop and review the screen before accepting.

## Next checkpoints

1. Create `GoogleDriveService.dart` using `GoogleSignIn.instance`, the Web client ID, and `drive.file`.
2. Add its Riverpod provider.
3. Add an owner-only “Connect Google Drive” test action.
4. Verify account authentication and creation of an authenticated Drive client.
5. Create the `AsKen POS/Transaction Logs` folder and store its Drive ID locally.
6. Implement Drive create/update for the daily CSV and TXT files using stored remote file IDs.
7. Connect Drive success/failure to `TransactionSyncBatchService`.
8. Add the owner Sync Center showing pending, failed, synced, retry, and last-error states.
9. Add password-protected AES ZIP export containing CSV/TXT before production use.
10. Add background scheduling after foreground sync is stable.
11. Implement thermal printing last, after selecting and testing an ESC/POS Android printer.

## Validation baseline

- Drift generation completed successfully after schema version 4.
- `dart analyze lib` returned no errors.
- `git diff --check` passed.
