import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 20, int skip = 0});

  Future<Product> getProduct(int id);

  Future<List<Product>> searchProducts(String query);
}

//This is important. The Domain says:"I need a repository that
//can give me products."It doesn't say:"Use Dio."
