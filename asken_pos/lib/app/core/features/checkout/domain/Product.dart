class ProductVariant {
  final int ID;
  final String ProductName;
  final String? brand;
  final String? color;
  final String? size;
  final String unit;
  final double price;

  const ProductVariant({
    required this.ID,
    required this.ProductName,
    this.brand,
    this.color,
    this.size,
    required this.unit,
    required this.price,
  });

  String get ProductDisplayName {
    final variations = [
      brand ?? '',
      ProductName,
      color ?? '' ,
      size ?? '',
    ];

    return variations.join(' ');
  }
}