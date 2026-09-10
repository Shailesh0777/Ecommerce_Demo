import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final controls = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  DecreaseQuantity(item.product.id),
                                );
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  IncreaseQuantity(item.product.id),
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  RemoveFromCart(item.product.id),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        );

                        final productInfo = Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text('\$${item.total.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );

                        final productImage = ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        );

                        if (constraints.maxWidth < 500) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Column(
                              children: [
                                Row(children: [productImage, productInfo]),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: controls,
                                ),
                              ],
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [productImage, productInfo, controls],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${state.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () {
                          context.read<CartBloc>().add(const ClearCart());
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
