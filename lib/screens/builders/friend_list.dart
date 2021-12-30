import 'package:anonylist/screens/builders/friend_item.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

class FriendList extends StatefulWidget {
  final bool showAll;
  final String searchQuery;
  final bool addFriend;
  final bool addToGroup;
  final String groupId;

  const FriendList({
    Key? key,
    this.showAll=false,
    this.searchQuery='',
    this.addFriend = false,
    this.addToGroup = false,
    this.groupId = '',
  })
      : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    bool show = true;
      //Displays all users that the current user is friends with
      return StreamBuilder<QuerySnapshot?>(
          stream: widget.addFriend ? database.userCollectionStream : database.friendsCollectionStream,
          //TODO Change to friend list database collection
          initialData: null,
          builder: (context, userCollectionSnapshot) {
            if (userCollectionSnapshot.hasError) {
              return Load();
            } else if (userCollectionSnapshot.hasData || userCollectionSnapshot.data != null) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var uid = userCollectionSnapshot.data!.docs[index].id;
                    dev.log(uid, name: "User ID Check");
                    var friendInfo = userCollectionSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                    if (widget.addFriend) {
                      show = false;
                      //TODO uncomment this later, only keeping it for expo
                      //TODO remove people the user is already friends with
                      if (/*widget.searchQuery.length > 2
                          &&*/ friendInfo['name'].toString().toLowerCase()
                              .contains(widget.searchQuery) && uid != database.uid) {
                        show = true;
                      }
                      dev.log(uid + ' : ' + show.toString(), name: "add friends");

                      return FriendItem(
                        uid: uid,
                        name: friendInfo['name'],
                        show: show,
                        addToGroup: widget.addToGroup,
                        addFriend: widget.addFriend,
                        groupId: widget.groupId,
                      );
                    } else {
                      return FutureBuilder<DocumentSnapshot?>(
                          future: DatabaseService().getUserDocFuture(uid),
                          initialData: null,
                          builder: (context, userInfoSnapshot) {
                            if (userInfoSnapshot.hasError) {
                              return Load();
                            } else if (userInfoSnapshot.hasData || userInfoSnapshot.data != null) {
                              var userInfo = userInfoSnapshot.data!.data() as Map<String, dynamic>;
                              show = true;
                              if (widget.searchQuery.length >= 2
                                  && !userInfo['name'].toString().toLowerCase()
                                      .contains(widget.searchQuery)) {
                                show = false;
                              }
                              dev.log(userInfoSnapshot.data!.data().toString() + ' : ' + show.toString(), name: "filter friends");
                              return FriendItem(
                                uid: uid,
                                name: userInfo['name'],
                                show: show,
                                addToGroup: widget.addToGroup,
                                addFriend: widget.addFriend,
                                groupId: widget.groupId,
                              );
                            } else {
                              return Load();
                            }
                          }
                      );
                    }
                  },
                  separatorBuilder: (context, index) =>
                  SizedBox(height: show ? 20.0 : 0.0),
                  itemCount: userCollectionSnapshot.data!.docs.length);
            } else {
              return Load();
            }
          }
      );
    }
}
