import 'package:anonylist/services/auth_svc.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/profile_pic.dart';
import 'package:anonylist/templates/container_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as dev;

import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  DatabaseService database = DatabaseService();

  final _nameKey = GlobalKey<FormState>();
  bool load = false;
  String name = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
              //Sign in Button

              onPressed: () async {
                if (_nameKey.currentState!.validate() && name != '') {
                  setState(() {
                    load = true;
                  });
                  dev.log(name, name: "name");
                  dynamic result = await database.editUser(name);
                  if (result == null) {
                    setState(() {
                      load = false;
                      err = "Invalid Credentials";
                    });
                  }
                }
              },
              icon: const Icon(Icons.save)
              //style: ButtonStyle(),
              ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
          children: [
            Form(
              key: _nameKey,
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ProfilePic(onTap: () async {
                        PickedFile? pic = await ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        if (pic != null) {
                          database.uploadProfilePic(pic);
                        }
                      }),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            initialValue: database.name,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person_outline_rounded),
                                border: OutlineInputBorder(),
                                filled: true,
                                // fillColor: Colors.white,
                                labelText: 'Name'),
                            validator: (input) =>
                            input!.isEmpty ? "Enter Name" : null,
                            onChanged: (input) {
                              setState(() {
                                name = input;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _auth.signOut();
                        },
                        icon: const Icon(Icons.logout),
                        alignment: Alignment.topRight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
                onPressed: () async {
                  String url = 'https://github.com/Lyxaaa/Anonylist';
                  if (await canLaunch(url)) {
                    await (launch(url));
                  }
                },
              label: Text("View Source"),
              icon: Icon(Icons.open_in_new),
            ),
          ],
        )

      ),
    );
  }

  Widget bd(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfilePic(onTap: () async {
                  PickedFile? pic = await ImagePicker.platform
                      .pickImage(source: ImageSource.gallery);
                  if (pic != null) {
                    database.uploadProfilePic(pic);
                  }
                }),
                CardContainer(
                    child: Text(
                  database.name,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _auth.signOut();
                      },
                      icon: const Icon(Icons.logout),
                      alignment: Alignment.topRight,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
    );
  }
}
