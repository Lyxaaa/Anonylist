import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/auth/sign_in.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:flutter/material.dart';

//Display auth info, allowing users to login, register or await auto login
class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Your Stats";
  }

  @override
  _StatsPage createState() => _StatsPage();
}

class _StatsPage extends State<Stats> with AutomaticKeepAliveClientMixin {
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
    // return StreamBuilder<DocumentSnapshot?>(
    //   //TODO set loading screen here to prevent error screen from momentarily showing
    //     stream: database.userDetailsStream,
    //     initialData: null,
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Load();
    //       } else {
    //         var userInfo = snapshot.data!.data() as Map<String, dynamic>;
    //         return StreamBuilder<DocumentSnapshot?>(
    //             stream: database.getSessionStream(userInfo['session_uid']),
    //             builder: (context, sessionSnapshot) {
    //               if (!sessionSnapshot.hasData || !sessionSnapshot.data!.exists) {
    //                 return Text('you have no session history');
    //               } else {
    //                 var sessionInfo = sessionSnapshot.data!.data() as Map<String, dynamic>;
    //                 bool active = sessionInfo[userInfo['session_uid']];
    //                 return Text('you have session history'/*sessionInfo['breaks'].toString()*/);
    //               }
    //             });
    //       }
    //     });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
