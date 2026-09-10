import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/prod_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0});

  Future<ProductModel> getProduct(int id);

  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0}) async {
    final response = await apiClient.get(
      ApiConstants.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );

    final products = response.data['products'] as List;

    return products.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final response = await apiClient.get('${ApiConstants.products}/$id');

    return ProductModel.fromJson(response.data);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await apiClient.get(
      ApiConstants.searchProducts,
      queryParameters: {'q': query},
    );

    final products = response.data['products'] as List;

    return products.map((json) => ProductModel.fromJson(json)).toList();
  }
}

//This class knows about the API. The UI doesn't.
