import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/container_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:numberpicker/numberpicker.dart';

class StartSession extends StatefulWidget {
  final String name;
  final String uid;

  const StartSession({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  DatabaseService database = DatabaseService();
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 30);
  bool _userInSession = false;
  int _breaks = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
