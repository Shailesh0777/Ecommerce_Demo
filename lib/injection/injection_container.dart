import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

import '../features/products/data/datasources/prod_remo_data_source.dart';
import '../features/products/data/repository/prod_repo_impl.dart';

import '../features/products/domain/repositories/prod_repo.dart';
import '../features/products/domain/usecases/get_products.dart';
import '../features/products/domain/usecases/search_prod.dart';

import '../features/products/presentation/bloc/prod_bloc.dart';
import '../features/carts/presentation/bloc/cart_bloc.dart';

class InjectionContainer {
  static late final ProductBloc productBloc;
  static late final CartBloc cartBloc;

  static void init() {
    // 1. Create Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
      ),
    );

    // 2. Inject Dio into ApiClient
    final apiClient = ApiClient(dio);

    // 3. Create data source
    final remoteDataSource =
        ProductRemoteDataSourceImpl(apiClient);

    // 4. Create repository
    final ProductRepository repository =
        ProductRepositoryImpl(remoteDataSource);

    // 5. Create use cases
    final getProducts = GetProducts(repository);
    final searchProducts = SearchProducts(repository);

    // 6. Inject use cases into BLoC
    productBloc = ProductBloc(
      getProducts: getProducts,
      searchProducts: searchProducts,
    );

    // Cart doesn't currently need an external dependency.
    cartBloc = CartBloc();
  }
}