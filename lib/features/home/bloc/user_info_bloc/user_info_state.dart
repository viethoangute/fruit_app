import 'package:training_example/models/user_info/user.dart' as user;

abstract class UserInfoState{}

class UserInfoLoadingState extends UserInfoState {
}

class UserInfoFetchedState extends UserInfoState {
  final user.UserInfo userInfo;

  UserInfoFetchedState({
    required this.userInfo,
  });
}

class ChangeNameSuccessState extends UserInfoState {
  final String name;

  ChangeNameSuccessState({
    required this.name,
  });
}

class ChangeAddressSuccessState extends UserInfoState {}