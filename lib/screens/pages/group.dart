import 'package:anonylist/screens/builders/friend_list.dart';
import 'package:anonylist/screens/builders/list_item.dart';
import 'package:anonylist/screens/builders/overlay_popup.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/screens/global/push_nav.dart';
import 'package:anonylist/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'friends.dart';

class Group extends StatefulWidget {
  final String groupName;
  final String groupId;

  const Group({
    Key? key,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          actions: <Widget>[
            Align(
                alignment: Alignment.centerRight,
                child: Row(children: <Widget>[
                  IconButton(
                    onPressed: () {
                      //PushNav().pushNavigation(context, FriendList(groupId: widget.groupId, addToGroup: true,), true);
                      showDialog(
                          context: context,
                          builder: (_) => OverlayPopup(
                            widthFactor: 0.9,
                            heightFactor: 0.9,
                            contents: Friends(
                              addToGroup: true,
                              groupId: widget.groupId,
                            ),
                          )
                      ).then((value) => {FocusScope.of(context).unfocus()});
                    },
                    icon: Icon(Icons.group_add),
                    // color: Colors.black87,
                  ),
                ]))
          ],
        ),
        body: StreamBuilder<QuerySnapshot?>(
            // Find the lists in the group
            stream: database.getLists(widget.groupId),
            initialData: null,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Load();
              } else {
                bool show = true;
                var lists = snapshot.data!.docs;

                return ListView.separated(
                  shrinkWrap: true,
                    // Create a component for each list
                    itemBuilder: (context, index) {
                      DocumentSnapshot userList = lists[index];
                      dev.log(userList.id, name: "User ID Check");
                      return StreamBuilder<QuerySnapshot?>(
                          // Find the items in the list
                          stream: database.getItems(
                              widget.groupId, userList.id),
                          initialData: null,
                          builder: (context, itemSnapshot) {
                            if (itemSnapshot.hasError) {
                              return Load();
                            } else if (itemSnapshot.hasData ||
                                itemSnapshot.data != null) {
                              List<DocumentSnapshot> listItems = itemSnapshot.data!.docs;
                              show = true;
                              return ListItem(
                                uid: userList.id,
                                list: listItems,
                                groupId: widget.groupId,
                              );
                            } else {
                              return Load();
                            }
                          });
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: show ? 20.0 : 0.0),
                    itemCount: lists.length);
              }
            }
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createListing(context);
        },
        tooltip: 'Add an item',
        child: const Icon(Icons.card_giftcard),
      ),
    );
  }

  void createListing(context) {
    final _nameKey = GlobalKey<FormState>();
    String name = '';
    String link = '';
    showDialog(context: context, builder: (context) =>
        SimpleDialog(
          title: Text('Add an item'),
          children: [
            Form(
              key: _nameKey,
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.card_giftcard),
                            border: OutlineInputBorder(),
                            filled: true,
                            // fillColor: Colors.white,
                            labelText: 'Item Name'),
                        validator: (input) => input!.isEmpty ? "Enter Item Name" : null,
                        onChanged: (input) {
                          setState(() {
                            name = input;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.link),
                            border: OutlineInputBorder(),
                            filled: true,
                            // fillColor: Colors.white,
                            labelText: 'Item Link'),
                        validator: (input) => input!.isEmpty ? "Enter Item Link" : null,
                        onChanged: (input) {
                          setState(() {
                            link = input;
                          });
                        },
                      ),
                    ],
                  )

              ),
            ),

            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  //style: ButtonStyle(),
                ),
                TextButton(
                  onPressed: () async {
                    if (_nameKey.currentState!.validate() && name != '') {
                      dev.log(name, name: "name");
                      DatabaseService().modifyList(widget.groupId, database.uid, name, name, link, false, '');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                  //style: ButtonStyle(),
                ),
              ],
            )

          ],
        ),
    );
  }
}
