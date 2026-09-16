import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get ID => integer().autoIncrement()();

  TextColumn get ProductName => text()();

  TextColumn get Brand => text().nullable()();

  BoolColumn get IsActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get CreatedAt =>
      dateTime().withDefault(currentDateAndTime)();
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

  TextColumn get Status =>
      text().withDefault(const Constant('completed'))();

  DateTimeColumn get CreatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class TransactionItems extends Table {
  IntColumn get ID => integer().autoIncrement()();

  IntColumn get TransactionID =>
      integer().references(Transactions, #ID)();

  IntColumn get ProductVariantID =>
      integer().references(ProductVariants, #ID)();

  TextColumn get ProductNameSnapshot => text()();

  TextColumn get UnitSnapshot => text()();

  IntColumn get UnitPriceInCents => integer()();

  IntColumn get Quantity => integer()();

  IntColumn get LineTotalInCents => integer()();
}

class StoreSettings extends Table {
  IntColumn get ID => integer().autoIncrement()();

  TextColumn get StoreName => text()();

  TextColumn get Address => text()();

  TextColumn get ContactNumber => text().nullable()();

  TextColumn get ReceiptFooter => text().nullable()();
}

