import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:training_example/models/remote_user_response.dart';

import '../features/users_list/service/api_service.dart';
import '../models/users.dart';

@singleton
class RemoteUserRepository {
  final ApiService apiService;

  const RemoteUserRepository({
    required this.apiService,
  });

  Future<List<RemoteUser>> getUsers({required int limit, required int skip}) async {
    try {
      var response = await apiService.fetchUsersData(limit: limit, skip: skip);
      final jsonResponse = json.decode(response.data);
      final fakeUserResponse = RemoteUserResponse.fromJson(jsonResponse);
      List<RemoteUser> users = fakeUserResponse.users ?? [];
      return users;
    } catch (e) {
      throw Exception('Can not load users from server: $e');
    }
  }
}
