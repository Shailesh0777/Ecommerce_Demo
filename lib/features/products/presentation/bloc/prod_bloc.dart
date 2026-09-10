import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_prod.dart';
import 'prod_event.dart';
import 'prod_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;

  ProductBloc({required this.getProducts, required this.searchProducts})
    : super(const ProductState()) {
    on<LoadProducts>(_loadProducts);
    on<SearchProductEvent>(_searchProducts);
  }

  Future<void> _loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = await getProducts(
        limit: 20,
        skip: (event.page - 1) * 20,
      );

      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _searchProducts(
    SearchProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(LoadProducts());
      return;
    }

    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = await searchProducts(event.query);

      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
