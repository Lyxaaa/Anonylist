import 'package:anonylist/templates/container_style.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/auth/sign_in.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Display auth info, allowing users to login, register or await auto login
class ActiveSession extends StatefulWidget {
  const ActiveSession({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Welcome Back";
  }

  @override
  _ActiveSessionPage createState() => _ActiveSessionPage();
}

class _ActiveSessionPage extends State<ActiveSession>
    with AutomaticKeepAliveClientMixin {
  DatabaseService database = DatabaseService();
  int _counter = 0;
  int _current = 0;
  bool _timerStarted = false;
  late CountdownTimer _timer;
  bool _timerElapsed = false;
  var _sub;

  String title() {
    return "Session in Progress";
  }

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
