import 'package:anonylist/screens/global/load.dart';
import 'package:anonylist/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'dart:developer'as dev;

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp({required this.toggle});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _signUpKey = GlobalKey<FormState>();
  bool load = false;
  String name = '';
  String email = '';
  String password = '';
  String verifyPassword = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return load ? Load() : Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        title: const Text("Sign up to Anonylist"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _signUpKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              TextFormField( //Input an email
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(),
                    filled: true,
                    // fillColor: Colors.white,
                    labelText: 'Enter your username'
                ),
                validator: (input) => input!.isEmpty ? "enter name": null,
                onChanged: (input) {
                  setState(() {
                    name = input;
                  });
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField( //Input an email
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
              TextFormField( //Input a password
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
              TextFormField( //Verify password was input correctly
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_open_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    // fillColor: Colors.white,
                    labelText: 'Repeat your password'
                ),
                validator: (input) => input?.compareTo(password) == 0 ? null : "passwords do not match",
                onChanged: (input) {
                  setState(() {
                    verifyPassword = input;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton( //Sign up button
                onPressed: () async {
                  if (_signUpKey.currentState!.validate()) {
                    setState(() {
                      load = true;
                    });
                    dev.log(email, name: "email");
                    dynamic result = await _auth.signUp(name, email, password);
                    if (result == null) {
                      setState(() {
                        load = false;
                        err = "Invalid Credentials";
                      });
                    }
                  }
                },
                child: const Text(
                  "Register",
                ),
                //style: ButtonStyle(),
              ),
              SizedBox(height: 20.0,),
              Text(
                err,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.toggle();
                    },
                    child: const Text(
                      "Back to Sign In",
                      // style: TextStyle(color: Colors.white),
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
