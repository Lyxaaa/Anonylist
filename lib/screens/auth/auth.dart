import 'package:anonylist/screens/auth/sign_in.dart';
import 'package:anonylist/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

//Display auth info, allowing users to login, register or await auto login
class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool signIn = true;

  void toggleSignIn() {
    dev.log("Sign In Toggle", name: signIn.toString());
    setState(() {
      signIn = !signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    dev.log("Sign In Page", name: signIn.toString());
    return signIn ? SignIn(toggle: toggleSignIn) : SignUp(toggle: toggleSignIn);
  }
}
