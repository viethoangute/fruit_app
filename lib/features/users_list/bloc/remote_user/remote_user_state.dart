import '../../../../models/users.dart';

abstract class RemoteUsersState {}

class RemoteUsersLoadingState extends RemoteUsersState {}

class RemoteUsersErrorState extends RemoteUsersState {
  final String error;

  RemoteUsersErrorState({required this.error});
}

class RemoteUsersFetchedState extends RemoteUsersState {
  final List<RemoteUser> users;

  RemoteUsersFetchedState({required this.users});
}

class RemoteUsersLoadingMoreState extends RemoteUsersState {
  final bool isLoading;

  RemoteUsersLoadingMoreState({required this.isLoading});
}
