import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/auth/auth.dart';
import 'package:anonylist/screens/builders/friend_list.dart';
import 'package:anonylist/screens/builders/overlay_popup.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/screens/pages/active_session.dart';
import 'package:anonylist/screens/pages/friends.dart';
import 'package:anonylist/screens/pages/home.dart';
import 'package:anonylist/screens/pages/profile.dart';
import 'package:anonylist/screens/pages/stats.dart';
import 'package:anonylist/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anonylist/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log("Create Home", name: "screens.main_scaffold.main_scaffold");
    return Container(
      child: MainScaffoldPage(title: "Anonylist"),
    );
  }
}

class MainScaffoldPage extends StatefulWidget {
  const MainScaffoldPage({Key? key, required this.title}) : super(key: key);

  // config for the state
  // holds the values (title below) provided by parent (App widget above)
  // used by build method of the State
  // Fields in a Widget subclass are always marked "final"

  final String title;

  @override
  State<MainScaffoldPage> createState() => _MainScaffoldPageState();
}

class _MainScaffoldPageState extends State<MainScaffoldPage>
    with AutomaticKeepAliveClientMixin {
  final AuthService _auth = AuthService();
  final DatabaseService database = DatabaseService();

  int _selectedIndex = 1;

  //Everything in the BottomNavigationBar should go here
  //If we have 3 items in the navbar, this list should have 3 widget elements
  static final List<Widget> _pages = <Widget>[
    Friends(),
    Home(),
  ];

  // bool _sessionActive = false;
  // void setSessionState(bool state) {
  //   if (_sessionActive != state) {
  //     _sessionActive = state;
  //     setState(() {
  //       _sessionActive ? _pages[0] = ActiveSession() : _pages[0] = Friends();
  //     });
  //   }
  // }


  void _onItemTapped(int index) {
    //setState() should be called EVERY TIME something that could impact the UI
    //is changed
    setState(() {
      _selectedIndex = index;
    });
  }

  void pushNavigation(BuildContext context, Widget dialog, bool fullscreen) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (BuildContext context) => dialog,
            fullscreenDialog: fullscreen,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    database.updateProfilePicUrl();
    super.build(context);
    //DatabaseService().userPreferences.map((querySnapshot) => querySnapshot.docs.map((doc) => Task))
    // rerunning build methods is extremely fast
    // just rebuild anything that needs updating rather than
    // individually changing instances of widgets.
    return StreamBuilder<DocumentSnapshot?>(
        //TODO set loading screen here to prevent error screen from momentarily showing
        stream: database.userDetailsStream,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Load();
          } else {
            var userInfo = snapshot.data!.data() as Map<String, dynamic>;
            //setSessionState(userInfo['session_active']);
            database.setName(userInfo['name']);
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        pushNavigation(context, Profile(), true);
                        // showDialog(
                        //     context: context,
                        //     builder: (_) =>
                        //         OverlayPopup(contents: Profile()
                        //         )
                        // );
                      },
                      icon: Icon(Icons.account_circle)),

                  centerTitle: true,
                  title: Text(
                      _pages.elementAt(_selectedIndex).toString(),
                  ),
                  elevation: 0.0,

                  actions: <Widget>[
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(children: <Widget>[
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => OverlayPopup(
                                        widthFactor: 0.9,
                                        heightFactor: 0.9,
                                        contents: Friends(
                                          addFriend: true,
                                        ),
                                      )
                              ).then((value) => {FocusScope.of(context).unfocus()});
                            },
                            icon: Icon(Icons.person_add),
                            // color: Colors.black87,
                          ),
                        ]))
                  ],
                ),
                body: Center(
                    child: _pages.elementAt(_selectedIndex)
                    // child: _pages.elementAt(_selectedIndex),
                    ),
                bottomNavigationBar: Container(
                    child: Material(
                      elevation: 0.0,
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        iconSize: 24,
                        elevation: 0,
                        // backgroundColor: Colors.transparent,
                        // fixedColor: Theme.of(context).colorScheme.onBackground,
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.people,
                                semanticLabel: "Friends Page"),
                            label: 'Friends',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.alarm_on,
                                semanticLabel: "Start Session"),
                            label: 'Sessions',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                      ),
                      // This trailing comma makes auto-formatting nicer for build methods.
                    )));
          }
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
