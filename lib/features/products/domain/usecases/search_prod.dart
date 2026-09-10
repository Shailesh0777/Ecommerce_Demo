import '../entities/product.dart';
import '../repositories/prod_repo.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<List<Product>> call(String query) {
    return repository.searchProducts(query);
  }
}
