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
  final Timestamp? lastSession;
  final int score;
  final String name;
  final bool show;

  const FriendItem(
      {Key? key,
      required this.uid,
      this.lastSession,
      this.score = -1,
      required this.name,
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
            if (widget.score == -1) {
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
            } else {
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          OverlayPopup(
                              widthFactor: 0.9,
                              heightFactor: 0.9,contents: StartSession(
                            name: widget.name, uid: widget.uid,)));
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
                          Text(
                            "Last Session: " +
                                DateFormat('MMMd').format(
                                    widget.lastSession!.toDate()),
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.score.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
    );
  }
}
