import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/auth/sign_in.dart';
import 'package:anonylist/screens/builders/friend_item.dart';
import 'package:anonylist/screens/builders/overlay_popup.dart';
import 'package:anonylist/screens/builders/start_session.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/container_style.dart';
import 'package:anonylist/templates/user_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
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
                    child: lastSessionInfo(
                        userInfo['session_uid'], userInfo['session_active']),
                    flex: 8,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    child: bestFriendInfo(
                        userInfo['session_uid'], userInfo['session_active']),
                    flex: 8,
                  ),
                  Spacer(
                    flex: 4,
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  StreamBuilder lastSessionInfo(String sessionUid, bool inSession) {
    return StreamBuilder<DocumentSnapshot?>(
      stream: database.getSessionStream(sessionUid),
      initialData: null,
      builder: (context, snapshot) {
        print("session b: " + snapshot.data!.data().toString());
        if (!snapshot.hasData || snapshot.hasError) {
          return const Load();
        } else if (!snapshot.data!.exists || snapshot.data == null) {
          return CardContainer(
            child: Column(
              children: const [
                Text(
                  'You have no session history',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Head over to the friends screen to get started!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          var sessionInfo = snapshot.data!.data() as Map<String, dynamic>;
          int breaks = sessionInfo['breaks'];
          Timestamp startTime = sessionInfo['start'];
          Timestamp endTime = sessionInfo['end'];
          String thisUser = database.uid;
          String otherName = sessionInfo[sessionUid + 'name'];
          int hours = sessionInfo['hours'];
          int minutes = sessionInfo['minutes'];
          int totalSeconds = endTime.seconds - startTime.seconds;
          int totalHours = (totalSeconds / 3600).floor();
          int totalMinutes = (totalSeconds / 60).floor().remainder(60);

          return CardContainer(
            child: Column(children:[Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inSession
                      ? 'You\'re still in a session with $otherName!'
                      : 'Your last session with $otherName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  inSession
                      ? 'Head back to your friends screen to continue your session'
                      : 'Your session lasted '
                      '${totalHours > 0 ? '${totalHours.toString()} hours ' : ''}'
                      '${totalHours > 0 && totalMinutes > 0 ? 'and ' : ''}'
                      '${totalHours == 0 || totalMinutes > 0 ? '${totalMinutes.toString()} minute' : ''}'
                      '${totalMinutes != 1 ? 's' : ''}, '
                      '${database.languageType ? 'and you kept focus for...' : 'but you only kept focus for...'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  inSession
                      ? ''
                      : '57%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45.0,
                  ),
                ),
                Text(
                  inSession
                      ? ''
                      : 'of the session',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            )]));
        }
      },
    );
  }

  StreamBuilder bestFriendInfo(String sessionUid, bool inSession) {
    return StreamBuilder<DocumentSnapshot?>(
      stream: database.getSessionStream(sessionUid),
      initialData: null,
      builder: (context, snapshot) {
        print("session b: " + snapshot.data!.data().toString());
        if (!snapshot.hasData || snapshot.hasError) {
          return const Load();
        } else if (!snapshot.data!.exists || snapshot.data == null) {
          return CardContainer(
            child: Column(
              children: const [
                Text(
                  'You have no session history',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Head over to the friends screen to get started!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          var sessionInfo = snapshot.data!.data() as Map<String, dynamic>;
          int breaks = sessionInfo['breaks'];
          Timestamp startTime = sessionInfo['start'];
          Timestamp endTime = sessionInfo['end'];
          String thisUser = database.uid;
          String otherName = sessionInfo[sessionUid + 'name'];
          int hours = sessionInfo['hours'];
          int minutes = sessionInfo['minutes'];
          int totalSeconds = endTime.seconds - startTime.seconds;
          int totalHours = (totalSeconds / 3600).floor();
          int totalMinutes = (totalSeconds / 60).floor().remainder(60);
          return InkWell(
            onTap: () {
              if (!inSession) {
                showDialog(
                    context: context,
                    builder: (_) =>
                        OverlayPopup(
                            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                            widthFactor: 0.9,
                            heightFactor: 0.9,
                            contents: StartSession(
                              name: otherName,
                              uid: sessionUid,
                            )));
              } else {
                database.endSession(sessionUid);
              }
            },
            child: CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inSession
                        ? 'You\'re still in a session with $otherName!'
                        : database.languageType ? 'You work best with...' : 'You work worst with...',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  FutureBuilder<String>(
                      future: database.findProfilePicUrl(sessionUid),
                      builder: (context, snapshot) {
                        return Row(children: <Widget>[
                          UserPic(url: snapshot.data.toString()),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(otherName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]);
                      }
                      ),
                  Spacer(),
                  Text(
                    inSession
                        ? 'Tap to end your session with $otherName'
                        : 'Tap to start a new session with $otherName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
