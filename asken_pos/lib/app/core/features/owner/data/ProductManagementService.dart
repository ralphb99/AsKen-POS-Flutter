import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class ProductManagementService {
  final AppDatabase Database;

  const ProductManagementService({required this.Database});

  Future<void> AddSellableItem({
    required String ProductName,
    String? Brand,
    String? Color,
    String? Size,
    required String Unit,
    required int PriceInCents,
  }) async {
    final CleanProductName = ProductName.trim();
    final CleanUnit = Unit.trim();

    if (CleanProductName.isEmpty) {
      throw ArgumentError('Product name is required.');
    }

    if (CleanUnit.isEmpty) {
      throw ArgumentError('Unit is required.');
    }

    if (PriceInCents < 0) {
      throw ArgumentError('Price cannot be negative.');
    }

    await Database.transaction(() async {
      final ProductID = await Database.AddProduct(
        ProductName: CleanProductName,
        Brand: _CleanOptionalValue(Brand),
      );

      await Database.AddProductVariant(
        ProductID: ProductID,
        Color: _CleanOptionalValue(Color),
        Size: _CleanOptionalValue(Size),
        Unit: CleanUnit,
        PriceInCents: PriceInCents,
      );
    });
  }

  Future<List<ProductDataRow>> SearchProducts({
    String Query = '',
    bool IncludeInactive = true,
  }) async {
    final ProductQuery = Database.select(Database.productVariants).join([
      innerJoin(
        Database.products,
        Database.products.ID.equalsExp(Database.productVariants.ProductID),
      ),
    ]);

    if (!IncludeInactive) {
      ProductQuery.where(
        Database.products.IsActive.equals(true) &
            Database.productVariants.IsActive.equals(true),
      );
    }

    final Rows = await ProductQuery.get();
    final SearchQuery = Query.trim().toLowerCase();

    return Rows.map((Row) {
          return ProductDataRow(
            StoreProduct: Row.readTable(Database.products),
            Variant: Row.readTable(Database.productVariants),
          );
        })
        .where((Row) {
          if (SearchQuery.isEmpty) {
            return true;
          }

          final SearchableText = [
            Row.StoreProduct.ProductName,
            Row.StoreProduct.Brand ?? '',
            Row.Variant.Color ?? '',
            Row.Variant.Size ?? '',
            Row.Variant.Unit,
          ].join(' ').toLowerCase();

          return SearchableText.contains(SearchQuery);
        })
        .toList(growable: false);
  }

  Future<void> UpdateProduct({
    required int ProductID,
    required String ProductName,
    String? Brand,
  }) async {
    final CleanProductName = ProductName.trim();

    if (CleanProductName.isEmpty) {
      throw ArgumentError('Product name is required.');
    }

    await (Database.update(
      Database.products,
    )..where((Product) => Product.ID.equals(ProductID))).write(
      ProductsCompanion(
        ProductName: Value(CleanProductName),
        Brand: Value(_CleanOptionalValue(Brand)),
      ),
    );
  }

  Future<void> UpdateProductVariant({
    required int ProductVariantID,
    String? Color,
    String? Size,
    required String Unit,
    required int PriceInCents,
  }) async {
    final CleanUnit = Unit.trim();

    if (CleanUnit.isEmpty) {
      throw ArgumentError('Unit is required.');
    }

    if (PriceInCents < 0) {
      throw ArgumentError('Price cannot be negative.');
    }

    await (Database.update(
      Database.productVariants,
    )..where((Variant) => Variant.ID.equals(ProductVariantID))).write(
      ProductVariantsCompanion(
        Color: Value(_CleanOptionalValue(Color)),
        Size: Value(_CleanOptionalValue(Size)),
        Unit: Value(CleanUnit),
        PriceInCents: Value(PriceInCents),
      ),
    );
  }

  Future<void> UpdateSellableItem({
    required int ProductID,
    required int ProductVariantID,
    required String ProductName,
    String? Brand,
    String? Color,
    String? Size,
    required String Unit,
    required int PriceInCents,
  }) async {
    await Database.transaction(() async {
      await UpdateProduct(
        ProductID: ProductID,
        ProductName: ProductName,
        Brand: Brand,
      );
      await UpdateProductVariant(
        ProductVariantID: ProductVariantID,
        Color: Color,
        Size: Size,
        Unit: Unit,
        PriceInCents: PriceInCents,
      );
    });
  }

  Future<void> SetProductActive({
    required int ProductID,
    required bool IsActive,
  }) async {
    await (Database.update(Database.products)
          ..where((Product) => Product.ID.equals(ProductID)))
        .write(ProductsCompanion(IsActive: Value(IsActive)));
  }

  Future<void> SetProductVariantActive({
    required int ProductVariantID,
    required bool IsActive,
  }) async {
    await (Database.update(Database.productVariants)
          ..where((Variant) => Variant.ID.equals(ProductVariantID)))
        .write(ProductVariantsCompanion(IsActive: Value(IsActive)));
  }

  String? _CleanOptionalValue(String? ValueToClean) {
    final CleanValue = ValueToClean?.trim();
    return CleanValue == null || CleanValue.isEmpty ? null : CleanValue;
  }
}
