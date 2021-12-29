import 'package:anonylist/services/database.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  final VoidCallback onTap;

  const ProfilePic({required this.onTap});

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    DatabaseService database = DatabaseService();
    return GestureDetector(
        onTap: widget.onTap,
        child: database.currentProfilePicUrl == null
            ? const CircleAvatar(
          radius: 50.0,
          child: Icon(Icons.photo_camera),
        )
            : CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage(database.currentProfilePicUrl!),
        )
    );
  }
}
