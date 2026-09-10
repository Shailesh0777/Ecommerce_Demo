import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<IncreaseQuantity>(_increaseQuantity);
    on<DecreaseQuantity>(_decreaseQuantity);
    on<ClearCart>(_clearCart);
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index >= 0) {
      // Product already exists → increase quantity.
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      // New product → add it to cart.
      items.add(CartItem(product: event.product, quantity: 1));
    }

    emit(CartState(items: items));
  }

  void _removeFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((item) => item.product.id != event.productId)
        .toList();

    emit(CartState(items: items));
  }

  void _increaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) return;

    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);

    emit(CartState(items: items));
  }

  void _decreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) return;

    final currentQuantity = items[index].quantity;

    if (currentQuantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: currentQuantity - 1);
    }

    emit(CartState(items: items));
  }

  void _clearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
