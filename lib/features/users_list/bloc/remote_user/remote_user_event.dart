abstract class RemoteUsersEvent {}

class FetchRemoteUsersEvent extends RemoteUsersEvent {
  final bool? isFirstTime;

  FetchRemoteUsersEvent({
    required this.isFirstTime,
  });
}