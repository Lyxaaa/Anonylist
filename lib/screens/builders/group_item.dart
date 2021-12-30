import 'package:anonylist/screens/builders/start_session.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/screens/pages/group.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/user_pic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:anonylist/screens/global/push_nav.dart';
import 'dart:developer' as dev;

import 'overlay_popup.dart';

class GroupItem extends StatefulWidget {
  final String name;
  final String id;
  final String description;
  final bool show;

  const GroupItem(
      {Key? key,
        this.description='Add a description of your group!',
        required this.id,
        required this.name,
        this.show=true})
      : super(key: key);

  @override
  _GroupItemState createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: database.findProfilePicUrl(widget.id),
      builder: (context, snapshot) {
          if (!widget.show) {
            return const SizedBox();
          } else {
              return InkWell(
                onTap: () {
                  PushNav().pushNavigation(context, Group(groupId: widget.id, groupName: widget.name,), true);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: UserPic(url: snapshot.data.toString()),
                        trailing: const Icon(Icons.chevron_right),
                        title: Text(widget.name),
                        subtitle: Text(widget.description,
                          style: TextStyle(color: Theme.of(context).primaryColorLight),),
                      )
                    ],
                  ),

                ),
              );
            }
          }
    );
  }
}
