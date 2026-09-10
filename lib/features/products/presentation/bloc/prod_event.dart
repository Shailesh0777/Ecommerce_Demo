import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final int page;

  const LoadProducts({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class SearchProductEvent extends ProductEvent {
  final String query;

  const SearchProductEvent(this.query);

  @override
  List<Object?> get props => [query];
}
