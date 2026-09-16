// class Product { 
//   final String ProductName;
//   final String Brand;

//   const Product({
//     required this.Brand,
//     required this.ProductName,
//   });
// }


// class ProductVariant {
//   final int ID;
//   final String brand;
//   final String color;
//   final String size;
//   final String unit;
//   final int priceInCents;

//   const ProductVariant({
//     required this.ID,
//     required this.brand,
//     required this.color,
//     required this.size,
//     required this.unit,
//     required this.priceInCents,
//   });

// }


import 'package:asken_pos/app/core/database/AppDatabase.dart';
class ProductDisplayData {
  final Product StoreProduct;
  final ProductVariant Variant;

  const ProductDisplayData ({
    required this.StoreProduct,
    required this.Variant,
  });

  String get ProductDisplayName {
    final ProductParts = [
      StoreProduct.Brand ?? '' ,
      StoreProduct.ProductName,
      Variant.Color ?? '' ,
      Variant.Size ?? '' ,
      Variant.Unit ,
    ].where((ProductParts) => ProductParts.isNotEmpty);
    return ProductParts.join('');
  }

}
