
abstract class UserInfoEvent{}

class FetchCurrentUserInfoEvent extends UserInfoEvent {}

class ChangeNameEvent extends UserInfoEvent {
  final String name;

  ChangeNameEvent({
    required this.name,
  });
}

class UpdateAddressEvent extends UserInfoEvent {
  final String province;
  final String district;
  final String commune;
  final String detail;

  UpdateAddressEvent({
    required this.province,
    required this.district,
    required this.commune,
    required this.detail,
  });
}