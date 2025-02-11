import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/constants/constants.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/users_list/bloc/remote_user/remote_user_event.dart';
import 'package:training_example/features/users_list/bloc/remote_user/remote_user_state.dart';
import 'package:training_example/repositories/remote_user_repository.dart';

import '../../../../models/users.dart';
import '../load_more/load_more_cubit.dart';

@singleton
class RemoteUsersBloc extends Bloc<RemoteUsersEvent, RemoteUsersState> {
  final RemoteUserRepository repository;
  final LoadMoreCubit loadMoreCubit;

  RemoteUsersBloc({required this.repository, required this.loadMoreCubit}) : super(RemoteUsersLoadingState()) {
    on<FetchRemoteUsersEvent>(_onFetchRemoteUsersEvent);
  }

  Future<void> _onFetchRemoteUsersEvent(FetchRemoteUsersEvent event, Emitter<RemoteUsersState> emit) async {
    try {
      var users = <RemoteUser>[];

      if (event.isFirstTime == true) {
        emit(RemoteUsersLoadingState());
        var data = await repository.getUsers(limit: Constants.userLoadingThreshold, skip: 0);
        users.addAll(data);
      } else {
        loadMoreCubit.showHideLoadMore(canShow: true);
        var fetchedUserState = state as RemoteUsersFetchedState;
        var oldUsers = fetchedUserState.users;
        var newUsers = await repository.getUsers(limit: Constants.userLoadingThreshold, skip: oldUsers.length);
        users.addAll(oldUsers);
        users.addAll(newUsers);
        loadMoreCubit.showHideLoadMore(canShow: false);
      }

      emit(RemoteUsersFetchedState(users: users));

    } on Exception catch (e) {
      emit(RemoteUsersErrorState(error: e.toString()));
    }
  }
}