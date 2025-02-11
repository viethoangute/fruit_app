import 'package:flutter/material.dart';

import '../../../models/users.dart';

class RemoteUserWidget extends StatelessWidget {
  final RemoteUser user;

  const RemoteUserWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: Image(
            image: NetworkImage('${user.image}'),
          ),
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text('Phone: ${user.phone}\nEmail: ${user.email}'),
        ),
      ),
    );
  }
}
