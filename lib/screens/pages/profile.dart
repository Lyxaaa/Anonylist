import 'package:anonylist/services/auth_svc.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/profile_pic.dart';
import 'package:anonylist/templates/container_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
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
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          database.updateLanguageType(!database.languageType);
                        });
                        },
                      child: Text(database.languageType ? 'Positive\nMode' : 'Negative\nMode',
                        textAlign: TextAlign.center,
                      ),
                      style: ButtonStyle(
                        backgroundColor: database.languageType ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Theme.of(context).errorColor),
                      ),
                    ),
                  ],
                )

              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Sessions:",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CardContainer(
              margin: 5,
              child: Row(
                children: [
                  const Expanded(
                    flex: 9,
                    child: SizedBox(height: 90),
                  ),
                  Expanded(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                          text: '2',
                          style: Theme.of(context).textTheme.headline3,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'sessions',
                                style: Theme.of(context).textTheme.bodyText2)
                          ]),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CardContainer(
              margin: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Session Average\n',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text('Average Number of minutes per session',
                            style: Theme.of(context).textTheme.overline
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(height: 90),
                  ),
                  Expanded(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                          text: '21',
                          style: Theme.of(context).textTheme.headline3,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'minutes',
                                style: Theme.of(context).textTheme.bodyText2)
                          ]),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CardContainer(
              margin: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level of Focus\n',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text('Amount of time you stay focused during a session',
                            style: Theme.of(context).textTheme.overline
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(height: 90),
                  ),
                  Expanded(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                          text: '77',
                          style: Theme.of(context).textTheme.headline3,
                          children: <TextSpan>[
                            TextSpan(
                                text: '%',
                                style: Theme.of(context).textTheme.bodyText2)
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
