import 'package:anonylist/services/database.dart';
import 'package:flutter/material.dart';

class UserPic extends StatelessWidget {
  final String? url;
  const UserPic({required this.url});

  @override
  Widget build(BuildContext context) {
    return url == 'null'
        ? CircleAvatar(
      radius: 20.0,
      child: Icon(
        Icons.person,
        size: 40.0,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      backgroundColor: Colors.transparent,
    )
        : CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(url!)
    );
  }
}
