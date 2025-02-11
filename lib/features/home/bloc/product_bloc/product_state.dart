import 'package:equatable/equatable.dart';
import 'package:training_example/models/product/product.dart';

abstract class ProductState extends Equatable {}

class ProductsLoadingState extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductsErrorState extends ProductState {
  final String error;

  ProductsErrorState({required this.error});

  @override
  List<Object?> get props => [];
}

class ProductsFetchedState extends ProductState {
  final List<Product> products;

  ProductsFetchedState({
    required this.products,
  });

  @override
  List<Object?> get props => products.toList();
}