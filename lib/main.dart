import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection/injection_container.dart';
import 'features/products/presentation/pages/homepage.dart';
import 'features/products/presentation/pages/prod_detail_page.dart';
import 'features/products/presentation/bloc/prod_bloc.dart';
import 'features/carts/presentation/pages/cart_page.dart';

void main() {
  // Build all dependencies before starting the application.
  InjectionContainer.init();

  runApp(const StoreDemoApp());
}

class StoreDemoApp extends StatelessWidget {
  const StoreDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Product BLoC
        BlocProvider.value(value: InjectionContainer.productBloc),

        // Global Cart BLoC
        BlocProvider.value(value: InjectionContainer.cartBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce Demo',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          scaffoldBackgroundColor: const Color(0xFFF7FAFA),
          useMaterial3: true,
        ),

        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/product': (context) {
            final productId =
                ModalRoute.of(context)?.settings.arguments as int?;
            final products = context.read<ProductBloc>().state.products;
            final matchingProducts = products.where(
              (item) => item.id == productId,
            );

            return ProductDetailPage(
              product: matchingProducts.isEmpty ? null : matchingProducts.first,
            );
          },
          '/cart': (_) => const CartPage(),
        },
      ),
    );
  }
}
