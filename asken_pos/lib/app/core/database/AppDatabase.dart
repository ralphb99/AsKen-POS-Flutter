import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:asken_pos/app/core/database/DatabaseTables.dart';
part 'AppDatabase.g.dart';

class ProductDataRow {
  final Product StoreProduct;
  final ProductVariant Variant;

  const ProductDataRow({required this.StoreProduct, required this.Variant});
}

@DriftDatabase(
  tables: [
    Products,
    ProductVariants,
    Transactions,
    TransactionItems,
    TransactionPrintJobs,
    TransactionSyncBatches,
    StoreSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'asken_pos_db',
          // web: DriftWebOptions(
          //   sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          //   driftWorker: Uri.parse('drift_worker.dart.js'),
          // ),
        ),
      );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator Migrator) async {
      await Migrator.createAll();
    },
    onUpgrade: (Migrator Migrator, int From, int To) async {
      if (From < 2) {
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.PaymentMethod,
          'payment_method',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.SyncStatus,
          'sync_status',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.SyncAttemptCount,
          'sync_attempt_count',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.LastSyncAttemptAt,
          'last_sync_attempt_at',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.SyncedAt,
          'synced_at',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.LastSyncError,
          'last_sync_error',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactions,
          transactions.SyncBatchID,
          'sync_batch_i_d',
        );
      }
      if (From < 3) {
        final HasTransactionSyncBatchesTable = await _HasTable(
          'transaction_sync_batches',
        );

        if (!HasTransactionSyncBatchesTable) {
          await Migrator.createTable(transactionSyncBatches);
        }
      }
      if (From < 4) {
        await _AddColumnIfMissing(
          Migrator,
          transactionSyncBatches,
          transactionSyncBatches.TextFileName,
          'text_file_name',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactionSyncBatches,
          transactionSyncBatches.TextLocalFilePath,
          'text_local_file_path',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactionSyncBatches,
          transactionSyncBatches.TextChecksum,
          'text_checksum',
        );
        await _AddColumnIfMissing(
          Migrator,
          transactionSyncBatches,
          transactionSyncBatches.RemoteTextFileID,
          'remote_text_file_i_d',
        );
      }
      if (From < 5) {
        final HasTransactionPrintJobsTable = await _HasTable(
          'transaction_print_jobs',
        );

        if (!HasTransactionPrintJobsTable) {
          await Migrator.createTable(transactionPrintJobs);
        }
      }
    },
  );

  Future<int> AddProduct({required String ProductName, String? Brand}) {
    return into(products).insert(
      ProductsCompanion.insert(ProductName: ProductName, Brand: Value(Brand)),
    );
  }

  Future<int> AddProductVariant({
    required int ProductID,
    String? Color,
    String? Size,
    required String Unit,
    required int PriceInCents,
  }) {
    return into(productVariants).insert(
      ProductVariantsCompanion.insert(
        ProductID: ProductID,
        Color: Value(Color),
        Size: Value(Size),
        Unit: Unit,
        PriceInCents: PriceInCents,
      ),
    );
  }

  Future<List<Product>> GetProducts() {
    return select(products).get();
  }

  Stream<List<Product>> WatchProducts() {
    return select(products).watch();
  }

  Future<List<ProductVariant>> GetProductVariants() {
    return select(productVariants).get();
  }

  Future<void> SeedProducts() async {
    //checks if the DB is already seeded
    final ExistingProducts = await GetProducts();

    if (ExistingProducts.isNotEmpty) {
      return;
    }

    final ProductID = await AddProduct(
      ProductName: 'Ballpen',
      Brand: 'FlexStick',
    );

    await AddProductVariant(
      ProductID: ProductID,
      Color: 'Black',
      Unit: 'pc',
      PriceInCents: 600,
    );

    await AddProductVariant(
      ProductID: ProductID,
      Color: 'Black',
      Unit: 'doz',
      PriceInCents: 6600,
    );

    await AddProductVariant(
      ProductID: ProductID,
      Color: 'Blue',
      Unit: 'pc',
      PriceInCents: 600,
    );
  }

  Future<void> EnsureStoreSettings() async {
    final ExistingSettings = await select(storeSettings).get();

    if (ExistingSettings.isNotEmpty) {
      return;
    }

    await into(storeSettings).insert(
      StoreSettingsCompanion.insert(
        StoreName: 'Educational Supply Store',
        Address: 'Address not configured',
        ContactNumber: const Value('Contact number not configured'),
        ReceiptFooter: const Value('Thank you for your purchase.'),
      ),
    );
  }

  Future<List<ProductDataRow>> GetProductData() {
    final ProductQuery =
        select(productVariants).join([
            innerJoin(
              products,
              products.ID.equalsExp(productVariants.ProductID),
            ),
          ])
          ..where(
            products.IsActive.equals(true) &
                productVariants.IsActive.equals(true),
          )
          ..orderBy([
            OrderingTerm(expression: products.ProductName),
            OrderingTerm(expression: productVariants.Unit),
          ]);

    return ProductQuery.map((row) {
      final DatabaseProduct = row.readTable(products);
      final DatabaseVariant = row.readTable(productVariants);

      return ProductDataRow(
        StoreProduct: Product(
          ID: DatabaseProduct.ID,
          ProductName: DatabaseProduct.ProductName,
          Brand: DatabaseProduct.Brand ?? '',
          IsActive: DatabaseProduct.IsActive,
          CreatedAt: DatabaseProduct.CreatedAt,
        ),
        Variant: ProductVariant(
          ID: DatabaseVariant.ID,
          ProductID: DatabaseVariant.ProductID,
          Color: DatabaseVariant.Color ?? '',
          Size: DatabaseVariant.Size ?? '',
          Unit: DatabaseVariant.Unit,
          PriceInCents: DatabaseVariant.PriceInCents,
          IsActive: DatabaseVariant.IsActive,
        ),
      );
    }).get();
  }

  Future<void> _AddColumnIfMissing(
    Migrator Migrator,
    TableInfo<Table, dynamic> Table,
    GeneratedColumn<Object> Column,
    String ColumnName,
  ) async {
    if (await _HasColumn(Table.actualTableName, ColumnName)) {
      return;
    }

    await Migrator.addColumn(Table, Column);
  }

  Future<bool> _HasTable(String TableName) async {
    final Result = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable.withString(TableName)],
    ).get();

    return Result.isNotEmpty;
  }

  Future<bool> _HasColumn(String TableName, String ColumnName) async {
    final Result = await customSelect('PRAGMA table_info("$TableName")').get();

    return Result.any((Row) => Row.data['name'] == ColumnName);
  }
}
