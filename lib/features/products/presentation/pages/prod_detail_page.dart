import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../carts/presentation/bloc/cart_bloc.dart';
import '../../../carts/presentation/bloc/cart_event.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    final isOutOfStock =
        product.stock == 0 || product.availabilityStatus == 'Out of Stock';
    final images = product.images.isEmpty
        ? [product.thumbnail]
        : product.images;
    final activeImage = images[selectedImage.clamp(0, images.length - 1)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildGallery(images, activeImage),
                              ),
                              const SizedBox(width: 48),
                              Expanded(
                                child: _buildInformation(product, isOutOfStock),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildGallery(images, activeImage),
                              const SizedBox(height: 28),
                              _buildInformation(product, isOutOfStock),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 36),
                const Divider(),
                const SizedBox(height: 24),
                Text(
                  'About this product',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(List<String> images, String activeImage) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.08,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              activeImage,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported_outlined, size: 48),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = selectedImage == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedImage = index),
                  child: Container(
                    width: 72,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInformation(Product product, bool isOutOfStock) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.category.toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 21),
            const SizedBox(width: 5),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'by ${product.brand}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 10,
          runSpacing: 4,
          children: [
            Text(
              '\$${product.discountedPrice.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.discountPercentage > 0) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '${product.discountPercentage.toStringAsFixed(0)}% off',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isOutOfStock ? Colors.red.shade50 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isOutOfStock
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline,
                size: 18,
                color: isOutOfStock
                    ? Colors.red.shade700
                    : Colors.green.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOutOfStock
                      ? 'Currently unavailable'
                      : '${product.stock} available in stock',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isOutOfStock
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: isOutOfStock
                ? null
                : () {
                    context.read<CartBloc>().add(AddToCart(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text(isOutOfStock ? 'Out of stock' : 'Add to cart'),
          ),
        ),
      ],
    );
  }
}
