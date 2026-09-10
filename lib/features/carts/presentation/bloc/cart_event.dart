import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class IncreaseQuantity extends CartEvent {
  final int productId;

  const IncreaseQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class DecreaseQuantity extends CartEvent {
  final int productId;

  const DecreaseQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
