import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../../../carts/presentation/bloc/cart_bloc.dart';
import '../../../carts/presentation/bloc/cart_event.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock =
        product.stock == 0 ||
        product.availabilityStatus == 'Out of Stock';

    final bool isLowStock =
        product.stock > 0 && product.stock <= 5;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // Clicking the card opens Product Details.
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product.id,
          );
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // PRODUCT IMAGE
            // ------------------------------------------------
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,

                      // Show something if image fails.
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                          ),
                        );
                      },

                      // Loading indicator while image loads.
                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),

                  // OUT OF STOCK LABEL
                  if (isOutOfStock)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius:
                              BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'Out of stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ------------------------------------------------
            // PRODUCT INFORMATION
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Product name
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // PRICE
                  // ------------------------------------------------
                  Row(
                    children: [
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: 8),

                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration:
                                TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // RATING + STOCK
                  // ------------------------------------------------
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.amber,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (isLowStock)
                        Expanded(
                          child: Text(
                            'Only ${product.stock} left',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.orange,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            '${product.stock} in stock',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // ADD TO CART
                  // ------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isOutOfStock
                          ? null
                          : () {
                              // Send event to GLOBAL CartBloc.
                              context.read<CartBloc>().add(
                                    AddToCart(product),
                                  );

                              // Small feedback.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Added to cart',
                                  ),
                                  duration:
                                      Duration(seconds: 1),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isOutOfStock
                            ? 'Out of Stock'
                            : 'Add to Cart',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}