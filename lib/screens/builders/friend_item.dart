import 'package:anonylist/screens/builders/start_session.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/user_pic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'overlay_popup.dart';

class FriendItem extends StatefulWidget {
  final String uid;
  final String name;
  final bool show;
  final bool addFriend;
  final bool addToGroup;
  final String groupId;

  const FriendItem(
      {Key? key,
      required this.uid,
      required this.name,
        this.addFriend = false,
        this.addToGroup = false,
        this.groupId = '',
      this.show=true})
      : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: database.findProfilePicUrl(widget.uid),
      builder: (context, snapshot) {
          if (!widget.show) {
            return const SizedBox();
          } else {
            if (widget.addFriend) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  child:
                  ListTile(
                    leading: UserPic(url: snapshot.data.toString()),
                    trailing: ElevatedButton.icon(
                        onPressed: () {
                          DatabaseService().addFriend(widget.uid);
                        },
                        label: const Text("add friend"),
                      icon: Icon(Icons.person_add),
                    ),
                    title: Text(widget.name),
                  )

              );
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Row(
                  children: <Widget>[
                    UserPic(url: snapshot.data.toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.name),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          DatabaseService().addFriend(widget.uid);
                        },
                        child: const Text("add friend"))
                  ],
                ),
              );
            } else if (widget.addToGroup) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  child:
                  ListTile(
                    leading: UserPic(url: snapshot.data.toString()),
                    trailing: ElevatedButton.icon(
                        onPressed: () {
                          DatabaseService().addUserToGroup(widget.groupId, widget.uid);
                        },
                        label: const Text("Add to group"),
                      icon: Icon(Icons.group_add),
                    ),
                    title: Text(widget.name),
                  )

              );
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Row(
                  children: <Widget>[
                    UserPic(url: snapshot.data.toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.name),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          DatabaseService().addUserToGroup(widget.groupId, widget.uid);
                        },
                        child: const Text("Add to this group"))
                  ],
                ),
              );
            } else {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  child:
                  ListTile(
                    leading: UserPic(url: snapshot.data.toString()),
                    trailing: ElevatedButton.icon(
                        onPressed: () {
                          DatabaseService().addUserToGroup(widget.groupId, widget.uid);
                        },
                        label: const Text("Remove friend"),
                      icon: Icon(Icons.delete),
                    ),
                    title: Text(widget.name),
                  )

              );
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Row(
                  children: <Widget>[
                    UserPic(url: snapshot.data.toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.name),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          //TODO Remove Friend
                        },
                        child: const Text("Remove friend"))
                  ],
                ),
              );
            }
          }
        },
    );
  }
}
