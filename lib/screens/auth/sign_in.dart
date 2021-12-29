import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn({required this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _signInKey = GlobalKey<FormState>();
  bool load = false;
  String email = '';
  String password = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return load ? Load() : Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        // backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0.0,
        title: const Text("Sign in to Anonylist"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _signInKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(),
                    filled: true,
                    // fillColor: Colors.white,
                    labelText: 'Enter your email'
                ),
                validator: (input) => input!.isEmpty ? "enter email": null,
                onChanged: (input) {
                  setState(() {
                    email = input;
                  });
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(),
                    filled: true,
                    // fillColor: Colors.white,
                    labelText: 'Enter your password'
                ),
                validator: (input) => input!.length < 6 ? "enter password (min 6 characters)": null,
                onChanged: (input) {
                  setState(() {
                    password = input;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton( //Sign in Button
                onPressed: () async {
                  if (_signInKey.currentState!.validate()) {
                    setState(() {
                      load = true;
                    });
                    dev.log(email, name: "email");
                    dynamic result = await _auth.signIn(email, password);
                    if (result == null) {
                      setState(() {
                        load = false;
                        err = "Invalid Credentials";
                      });
                    }
                  }
                },
                child: const Text(
                  "Sign In",
                  //style: TextStyle(color: Colors.black),
                ),
                //style: ButtonStyle(),
              ),
              SizedBox(height: 20.0,),
              Text(
                err,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
                // style: TextStyle(color: Theme.of(context).textTheme., fontSize: 14.0)
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      dev.log("Switch pressed");
                      widget.toggle();
                    },
                    child: const Text(
                      "Don't have an account? Register Here",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ElevatedButton(
          child: const Text("Sign in Anonymously"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              dev.log("Error signing in Anonymously", name: "screens.auth.sign_in");
            } else {
              dev.log("Signed in Anonymously: " + result.uid, name: "screens.auth.sign_in");
            }
          },
        ),
 */
