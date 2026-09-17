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

class ProductDisplayData {
  final int ProductID;
  final int ProductVariantID;
  final String ProductName;
  final String? Brand;
  final String? Color;
  final String? Size;
  final String Unit;
  final int PriceInCents;

  const ProductDisplayData({
    required this.ProductID,
    required this.ProductVariantID,
    required this.ProductName,
    this.Brand,
    this.Color,
    this.Size,
    required this.Unit,
    required this.PriceInCents,
  });

  String get ProductDisplayName {
    final ProductParts = [
      Brand ?? '',
      ProductName,
      Color ?? '',
      Size ?? '',
    ].where((Part) => Part.isNotEmpty);

    return ProductParts.join('--');
  }
}
