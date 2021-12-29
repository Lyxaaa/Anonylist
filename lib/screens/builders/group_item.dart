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

class GroupItem extends StatefulWidget {
  final String name;
  final String id;
  final String description;
  final bool show;

  const GroupItem(
      {Key? key,
        this.description='placeholder',
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
                  showDialog(
                      context: context,
                      builder: (_) =>
                          OverlayPopup(
                              widthFactor: 0.9,
                              heightFactor: 0.9,contents: StartSession(
                            name: widget.name, uid: widget.id,)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5),
                  child: Row(
                    children: <Widget>[
                      UserPic(url: snapshot.data.toString()),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(widget.description,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              );
            }
          }
    );
  }
}
