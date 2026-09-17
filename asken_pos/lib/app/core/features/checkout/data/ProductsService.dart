import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';

class ProductsService {
  final AppDatabase Database;

  const ProductsService({
    required this.Database,
  });

  Future<List<ProductDisplayData>> GetProductData() async {
    final ProductRows = await Database.GetProductData();

    return ProductRows.map((Row) {
      return ProductDisplayData(
        ProductID: Row.StoreProduct.ID,
        ProductVariantID: Row.Variant.ID,
        ProductName: Row.StoreProduct.ProductName,
        Brand: Row.StoreProduct.Brand,
        Color: Row.Variant.Color,
        Size: Row.Variant.Size,
        Unit: Row.Variant.Unit,
        PriceInCents: Row.Variant.PriceInCents,
      );
    }).toList(growable: false);
  }
}