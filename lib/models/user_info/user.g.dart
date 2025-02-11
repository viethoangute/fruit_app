// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInfo _$$_UserInfoFromJson(Map<String, dynamic> json) => _$_UserInfo(
      username: json['username'] as String,
      name: json['name'] as String,
      imageURL: json['imageURL'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      commune: json['commune'] as String?,
      detailAddress: json['detailAddress'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$_UserInfoToJson(_$_UserInfo instance) =>
    <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'imageURL': instance.imageURL,
      'province': instance.province,
      'district': instance.district,
      'commune': instance.commune,
      'detailAddress': instance.detailAddress,
      'phone': instance.phone,
    };
