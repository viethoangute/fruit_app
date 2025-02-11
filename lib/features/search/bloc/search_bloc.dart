import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/features/search/bloc/search_event.dart';
import 'package:training_example/features/search/bloc/search_state.dart';
import 'package:training_example/repositories/product_repository.dart';

@singleton
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitState()) {
    on<SearchRequestEvent>(_onSearchRequest);
  }

  Future<void> _onSearchRequest(
      SearchRequestEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    var rs = await repository.searchProducts(keyword: event.keyword);
    emit(SearchResultState(result: rs));
  }
}
