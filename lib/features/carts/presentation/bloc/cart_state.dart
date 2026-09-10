import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({
    this.items = const [],
  });

  double get total {
    return items.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  int get itemCount {
    return items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  @override
  List<Object?> get props => [items];
}