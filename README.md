<<<<<<< HEAD
# Ecommerce App

A Flutter shopping app demo that loads products from the DummyJSON API and
provides product browsing, search, product details, and a local shopping cart.

## Features

- Browse products fetched from `https://dummyjson.com`
- Search the product catalog
- View product details
- Add products to a cart and manage cart state
- Material 3 user interface

## Requirements

- Flutter SDK with Dart SDK `3.8.1` or newer
- An Android, iOS, desktop, or web device supported by Flutter
- Network access to the DummyJSON API when loading products

## Getting Started

```bash
flutter pub get
flutter run
```

To check the project before running it:

```bash
flutter analyze
flutter test
```

## Project Structure

```text
lib/
	core/                 Shared constants and networking
	features/
		products/           Product data, domain logic, BLoC, and screens
		carts/              Cart BLoC and cart screen
		favourites/         Favourites BLoC and related state
	injection/            Application dependency setup
	main.dart             App entry point and routes
```

The application follows a feature-first structure. Product data flows through
a remote data source, repository, use cases, and `ProductBloc`. Dependencies
are assembled in `InjectionContainer` before the app starts.

## Main Routes

| Route | Screen |
| --- | --- |
| `/` | Product home page |
| `/product` | Product details; expects a product ID argument |
| `/cart` | Shopping cart |

## Dependencies

- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) for application state
- [`dio`](https://pub.dev/packages/dio) for HTTP requests
- [`equatable`](https://pub.dev/packages/equatable) for value comparisons
- [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) for icons
=======
# Ecommerce_Demo
A simple Flutter e-commerce app using the DummyJSON REST API. Built with Clean Architecture, BLoC for state management, Repository Pattern, and Dependency Injection. Features include product browsing, search, product details, cart management, and responsive UI for mobile and web.
>>>>>>> 7aac61449de7b90aa4a38afee2fb0a6268825e29
