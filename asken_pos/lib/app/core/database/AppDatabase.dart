import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:asken_pos/app/core/database/DatabaseTables.dart';

part 'AppDatabase.g.dart';

@DriftDatabase(
  tables: [
    Products,
    ProductVariants,
    Transactions,
    TransactionItems,
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
  int get schemaVersion => 1;

}
