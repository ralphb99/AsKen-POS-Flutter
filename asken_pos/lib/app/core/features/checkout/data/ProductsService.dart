import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';

class ProductsService {
  final AppDatabase Database;

  const ProductsService({
    required this.Database,
  });

  Future<List<ProductDisplayData>> GetProductData() {
    return Database.GetProductData();
  }
}