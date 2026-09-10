import '../../domain/entities/product.dart';
import '../../domain/repositories/prod_repo.dart';
import '../datasources/prod_remo_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) {
    return remoteDataSource.getProducts(limit: limit, skip: skip);
  }

  @override
  Future<Product> getProduct(int id) {
    return remoteDataSource.getProduct(id);
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return remoteDataSource.searchProducts(query);
  }
}

//after this BLoC -> Use Case -> Repository -> Data Source -> API
