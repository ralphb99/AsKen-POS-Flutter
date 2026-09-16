import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:asken_pos/app/core/database/DatabaseTables.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart'
    as CheckoutData;
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

  
  Future<int> AddProduct({
  required String ProductName,
  String? Brand,
}) {
  return into(products).insert(
    ProductsCompanion.insert(
      ProductName: ProductName,
      Brand: Value(Brand),
    ),
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

Future<List<CheckoutData.ProductDisplayData>> GetProductData() {
  final ProductQuery = select(productVariants).join([
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

    return CheckoutData.ProductDisplayData(
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

}
