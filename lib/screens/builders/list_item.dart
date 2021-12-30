import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class ListItem extends StatefulWidget {
  final List<DocumentSnapshot> list;
  final String uid;
  final String groupId;

  const ListItem({
    Key? key,
    required this.uid,
    required this.list,
    required this.groupId
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _expanded = false;
  List<bool> _checked = [];

  @override
  Widget build(BuildContext context) {
    _checked = List.filled(widget.list.length, false);
    return Container(
      child: ExpansionPanelList(
        animationDuration: Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return FutureBuilder<DocumentSnapshot?>(
                  future: DatabaseService().getUserDocFuture(widget.uid),
                  initialData: null,
                  builder: (context, userInfoSnapshot) {
                    if (userInfoSnapshot.hasError) {
                      return Load();
                    } else if (userInfoSnapshot.hasData ||
                        userInfoSnapshot.data != null) {
                      var userInfo =
                          userInfoSnapshot.data!.data() as Map<String, dynamic>;
                      //dev.log(userInfoSnapshot.data!.data().toString() +
                      //   ' : ' + show.toString(), name: "filter friends");
                      return ListTile(title: Text(userInfo['name']));
                    } else {
                      return Load();
                    }
                  });
            },
            body: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  dev.log(widget.list[index].data().toString());
                  if (widget.uid == DatabaseService().uid) {
                    return duplicateUserListing(context, index);
                  }
                  return otherUserListing(context, index);
                },
                separatorBuilder: (context, index) => SizedBox(height: 20.0),
                itemCount: widget.list.length),
            isExpanded: _expanded,
            canTapOnHeader: true,
          ),
        ],
        expansionCallback: (int item, bool status) {
          setState(() {
            _expanded = !_expanded;
          });
        },
      ),
    );
  }
  
  Widget otherUserListing(context, index) {
    var listItems = widget.list[index].data() as Map<String, dynamic>;
    _checked[index] = listItems['taken'];
    if (_checked[index] == false || DatabaseService().uid == listItems['taken_by']) {
      return Row(
        children: [
          Checkbox(
              value: _checked[index],
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    _checked[index] = value;
                  }
                  DatabaseService().modifyList(
                      widget.groupId,
                      widget.uid,
                      null,
                      listItems['origin'],
                      null,
                      value,
                      DatabaseService().uid);
                });
              }
          ),
          Text(listItems['name']),
          Spacer(),
          IconButton(
              onPressed: () async {
                String url = listItems['link'];
                if (await canLaunch(url)) {
                  await (launch(url));
                }
              }, icon: Icon(Icons.open_in_new)
          )
        ],
      );
    }
    return SizedBox(height: 0.0,);
  }

  Row duplicateUserListing(context, index) {
    var listItems = widget.list[index].data() as Map<String, dynamic>;
    _checked[index] = listItems['taken'];
    return Row(
      children: [
        Text(listItems['name']),
        Spacer(),
        IconButton(
            onPressed: () async {
              modifyListing(context, index);
            }, icon: Icon(Icons.edit)
        ),
        IconButton(
            onPressed: () {
              DatabaseService().deleteItem(widget.groupId, widget.uid, listItems['origin']);
        }, icon: Icon(Icons.delete))
      ],
    );
  }

  void changeListing(context, int? index) {
    if (index != null) {
      modifyListing(context, index);
    }
  }

  void claimListing(context, int index, bool claim, String? claimedBy) {

  }


  void modifyListing(context, int index) {
      var listItems = widget.list[index].data() as Map<String, dynamic>;
      final _nameKey = GlobalKey<FormState>();
      String? name;
      String? link;
      showDialog(context: context, builder: (context) =>
          SimpleDialog(
            title: Text('Modify this item'),
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
                        initialValue: listItems['name'],
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
                        initialValue: listItems['link'],
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
                        //dev.log(name, name: "name");
                        DatabaseService().modifyList(widget.groupId, widget.uid, name, listItems['origin'], link, null, null);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Finish'),
                    //style: ButtonStyle(),
                  ),
                ],
              )

            ],
          ),
      );
  }
}
