import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../carts/presentation/bloc/cart_bloc.dart';
import '../../../carts/presentation/bloc/cart_state.dart';
import '../bloc/prod_bloc.dart';
import '../bloc/prod_event.dart';
import '../bloc/prod_state.dart';
import '../widgets/prod_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  int currentPage = 1;
  static const totalPages = 10;

  @override
  void initState() {
    super.initState();

    // Load products when the page opens.
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecommerce Demo'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),

                  if (state.itemCount > 0)
                    Positioned(
                      right: 3,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${state.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                context.read<ProductBloc>().add(SearchProductEvent(value));
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();

                    context.read<ProductBloc>().add(LoadProducts());
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == ProductStatus.failure) {
                  return Center(child: Text(state.errorMessage));
                }

                if (state.products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: state.products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _paginationItemsForWidth(constraints.maxWidth),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _paginationItemsForWidth(double width) {
    final previous = TextButton(
      onPressed: currentPage > 1 ? () => _changePage(currentPage - 1) : null,
      child: const Text('Prev'),
    );
    final next = TextButton(
      onPressed: currentPage < totalPages
          ? () => _changePage(currentPage + 1)
          : null,
      child: const Text('Next'),
    );

    if (width < 400) {
      return [previous, _pageButton(currentPage), next];
    }

    if (width < 600) {
      return [previous, ..._compactPaginationItems(), next];
    }

    return [previous, ..._paginationItems(), next];
  }

  List<Widget> _compactPaginationItems() {
    final pages = currentPage <= 2
        ? [1, 2, 3]
        : currentPage >= totalPages - 1
        ? [totalPages - 2, totalPages - 1, totalPages]
        : [currentPage - 1, currentPage, currentPage + 1];
    final items = <Widget>[];

    if (pages.first > 1) {
      items.add(_pageButton(1));
      items.add(_ellipsis());
    }

    for (final page in pages) {
      items.add(_pageButton(page));
    }

    if (pages.last < totalPages) {
      items.add(_ellipsis());
      items.add(_pageButton(totalPages));
    }

    return items;
  }

  List<Widget> _paginationItems() {
    final pages = <int>[];

    if (currentPage <= 4) {
      pages.addAll([1, 2, 3, 4, 5]);
    } else if (currentPage >= totalPages - 3) {
      pages.addAll([
        totalPages - 4,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
        totalPages,
      ]);
    } else {
      pages.addAll([
        currentPage - 2,
        currentPage - 1,
        currentPage,
        currentPage + 1,
        currentPage + 2,
      ]);
    }

    final items = <Widget>[];
    if (pages.first > 1) {
      items.add(_pageButton(1));
      items.add(_ellipsis());
    }

    for (final page in pages) {
      items.add(_pageButton(page));
      if (page != pages.last) {
        items.add(const SizedBox(width: 8));
      }
    }

    if (pages.last < totalPages) {
      items.add(_ellipsis());
      items.add(_pageButton(totalPages));
    }

    return items;
  }

  Widget _ellipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('...', style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _pageButton(int page) {
    final isSelected = page == currentPage;

    return SizedBox(
      width: 34,
      height: 38,
      child: TextButton(
        onPressed: () => _changePage(page),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text('$page'),
      ),
    );
  }

  void _changePage(int page) {
    setState(() => currentPage = page);
    context.read<ProductBloc>().add(LoadProducts(page: page));
  }
}
