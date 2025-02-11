import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class LoadMoreCubit extends Cubit<bool> {
  LoadMoreCubit() : super(false);

  void showHideLoadMore({required bool canShow}) {
    emit(canShow);
  }
}