import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/features/home/bloc/product_bloc/product_event.dart';
import 'package:training_example/features/home/bloc/product_bloc/product_state.dart';
import 'package:training_example/repositories/product_repository.dart';

@singleton
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductsLoadingState()) {
    on<FetchProductsEvent>(_onFetchProductRequest);
  }

  Future<void> _onFetchProductRequest(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoadingState());
      var products = await repository.getListProduct(category: event.category);
      emit(ProductsFetchedState(products: products));
    } on FirebaseException catch (e) {
      emit(ProductsErrorState(error: e.toString()));
    }
  }
}
