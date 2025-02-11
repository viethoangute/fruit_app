import 'package:training_example/models/users.dart';

class RemoteUserResponse {
  List<RemoteUser>? users;
  int? total;
  int? skip;
  int? limit;

  RemoteUserResponse({this.users, this.total, this.skip, this.limit});

  RemoteUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <RemoteUser>[];
      json['users'].forEach((v) {
        users!.add(RemoteUser.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}
