class ProductVariant {
  final int ID;
  final String ProductName;
  final String? brand;
  final String? color;
  final String? size;
  final String unit;
  final int priceInCents;

  const ProductVariant({
    required this.ID,
    required this.ProductName,
    this.brand,
    this.color,
    this.size,
    required this.unit,
    required this.priceInCents,
  });

  String get ProductDisplayName {
    final parts = [
      brand ?? '',
      ProductName,
      color ?? '',
      size ?? '',
    ];

    return parts.join(' ');
  }
}
