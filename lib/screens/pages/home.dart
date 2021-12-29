import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/auth/sign_in.dart';
import 'package:anonylist/screens/builders/group_item.dart';
import 'package:anonylist/screens/builders/overlay_popup.dart';
import 'package:anonylist/screens/builders/start_session.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/container_style.dart';
import 'package:anonylist/templates/user_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

//Display auth info, allowing users to login, register or await auto login
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Welcome Back";
  }

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  DatabaseService database = DatabaseService();

  String title() {
    return "Welcome Back " + database.name;
  }

  void _createGroup() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      database.createGroupGlobal('Test Group');
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILDING HOME");
    super.build(context);
    return StreamBuilder<DocumentSnapshot?>(
      stream: database.userDetailsStream,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Load();
        } else {
          print("session a: " + snapshot.data!.data().toString());
          var userInfo = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    title(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: groups(userInfo),
                    flex: 8,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _createGroup,
              tooltip: 'Create new Group',
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  CardContainer groups(Map<String, dynamic> userInfo) {
    if (userInfo['groups'].length == 0) {
          return CardContainer(
            child: Column(
              children: const [
                Text(
                  'You have no groups!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Tap the + to get started!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
        } else {
      String thisUser = database.uid;
      var groups = userInfo['groups'];
      bool show = true;

      return CardContainer(
          child: ListView.separated(
              itemBuilder: (context, index) {
                var groupName = groups[index];
                dev.log(database.uid, name: "User ID Check");

                return FutureBuilder<DocumentSnapshot?>(
                    future: DatabaseService().getGroupFuture(groupName),
                    initialData: null,
                    builder: (context, groupSnapshot) {
                      if (groupSnapshot.hasError) {
                        return Load();
                      } else
                      if (groupSnapshot.hasData || groupSnapshot.data != null) {
                        var groupInfo = groupSnapshot.data!.data() as Map<
                            String,
                            dynamic>; //TODO Find out how to reference a doc cell
                        show = true;
                        dev.log(groupSnapshot.data!.data().toString() + ' : ' +
                            show.toString(), name: "filter friends");
                        return GroupItem(
                          name: groupInfo['name'],
                          id: groupName,
                          show: show,
                        );
                      } else {
                        return Load();
                      }
                    }
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: show ? 20.0 : 0.0),
              itemCount: groups.length));
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
