import '../entities/product.dart';
import '../repositories/prod_repo.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call({int limit = 20, int skip = 0}) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
