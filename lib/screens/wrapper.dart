import 'package:anonylist/screens/auth/auth.dart';
import 'package:anonylist/screens/main_scaffold/main_scaffold.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

//Holds the screens of the application
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log('wrapper', name: 'screens.wrapper');

    //Forces anything that relies on the status of User to be triggered upon change
    final user = Provider.of<AppUser?>(context);
    if (user != null && user.uid != null) {
      DatabaseService(uid: user.uid);
    }

    dev.log("Obtained user: " + user.toString());
    return user == null ? Auth() : MainScaffold();
    //Return Home/Auth widget
    //return Auth();
  }
}
