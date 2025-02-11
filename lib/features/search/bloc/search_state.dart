import 'package:equatable/equatable.dart';

import '../../../models/product/product.dart';

abstract class SearchState extends Equatable {}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchInitState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchResultState extends SearchState {
  final List<Product> result;

  SearchResultState({
    required this.result,
  });

  @override
  List<Object?> get props => [];
}