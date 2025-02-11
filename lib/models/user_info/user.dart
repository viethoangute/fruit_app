import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'imageURL') String? imageURL,
    @JsonKey(name: 'province') String? province,
    @JsonKey(name: 'district') String? district,
    @JsonKey(name: 'commune') String? commune,
    @JsonKey(name: 'detailAddress') String? detailAddress,
    @JsonKey(name: 'phone') String? phone
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, Object?> json) =>
      _$UserInfoFromJson(json);
}
