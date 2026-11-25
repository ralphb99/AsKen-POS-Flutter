import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get ID => integer().autoIncrement()();

  TextColumn get ProductName => text()();

  TextColumn get Brand => text().nullable()();

  BoolColumn get IsActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get CreatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ProductVariants extends Table {
  IntColumn get ID => integer().autoIncrement()();

  IntColumn get ProductID => integer().references(Products, #ID)();

  TextColumn get Color => text().nullable()();

  TextColumn get Size => text().nullable()();

  TextColumn get Unit => text()();

  IntColumn get PriceInCents => integer()();

  BoolColumn get IsActive => boolean().withDefault(const Constant(true))();
}

class Transactions extends Table {
  IntColumn get ID => integer().autoIncrement()();

  TextColumn get ReceiptNumber => text().unique()();

  TextColumn get CashierName => text()();

  IntColumn get TotalInCents => integer()();

  TextColumn get Status => text().withDefault(const Constant('completed'))();

  TextColumn get PaymentMethod => text().withDefault(const Constant('cash'))();

  /// pending, uploading, synced, or failed.
  TextColumn get SyncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get SyncAttemptCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get LastSyncAttemptAt => dateTime().nullable()();

  DateTimeColumn get SyncedAt => dateTime().nullable()();

  TextColumn get LastSyncError => text().nullable()();

  TextColumn get SyncBatchID => text().nullable()();

  DateTimeColumn get CreatedAt => dateTime().withDefault(currentDateAndTime)();
}

class TransactionItems extends Table {
  IntColumn get ID => integer().autoIncrement()();

  IntColumn get TransactionID => integer().references(Transactions, #ID)();

  IntColumn get ProductVariantID =>
      integer().references(ProductVariants, #ID)();

  TextColumn get ProductNameSnapshot => text()();

  TextColumn get UnitSnapshot => text()();

  IntColumn get UnitPriceInCents => integer()();

  IntColumn get Quantity => integer()();

  IntColumn get LineTotalInCents => integer()();
}

class TransactionPrintJobs extends Table {
  IntColumn get ID => integer().autoIncrement()();

  IntColumn get TransactionID =>
      integer().unique().references(
        Transactions,
        #ID,
        onDelete: KeyAction.cascade,
      )();

  /// pending, printing, printed, or failed.
  TextColumn get Status => text().withDefault(const Constant('pending'))();

  IntColumn get AttemptCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get LastAttemptAt => dateTime().nullable()();

  DateTimeColumn get PrintedAt => dateTime().nullable()();

  TextColumn get LastError => text().nullable()();

  DateTimeColumn get CreatedAt => dateTime().withDefault(currentDateAndTime)();
}

class TransactionSyncBatches extends Table {
  IntColumn get ID => integer().autoIncrement()();

  /// One stable key per local business date, formatted as YYYY-MM-DD.
  TextColumn get BusinessDate => text().unique()();

  TextColumn get FileName => text()();

  TextColumn get TextFileName => text().nullable()();

  TextColumn get LocalFilePath => text().nullable()();

  TextColumn get TextLocalFilePath => text().nullable()();

  TextColumn get RemoteFileID => text().nullable()();

  TextColumn get RemoteTextFileID => text().nullable()();

  TextColumn get Checksum => text().nullable()();

  TextColumn get TextChecksum => text().nullable()();

  IntColumn get RecordCount => integer().withDefault(const Constant(0))();

  /// pending, uploading, synced, or failed.
  TextColumn get Status => text().withDefault(const Constant('pending'))();

  IntColumn get AttemptCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get LastAttemptAt => dateTime().nullable()();

  TextColumn get LastError => text().nullable()();

  DateTimeColumn get UploadedAt => dateTime().nullable()();

  DateTimeColumn get CreatedAt => dateTime().withDefault(currentDateAndTime)();
}

class StoreSettings extends Table {
  IntColumn get ID => integer().autoIncrement()();

  TextColumn get StoreName => text()();

  TextColumn get Address => text()();

  TextColumn get ContactNumber => text().nullable()();

  TextColumn get ReceiptFooter => text().nullable()();
}
