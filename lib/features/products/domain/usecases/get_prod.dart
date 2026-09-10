import '../entities/product.dart';
import '../repositories/prod_repo.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Product> call(int id) {
    return repository.getProduct(id);
  }
}