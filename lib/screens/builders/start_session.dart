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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        Text(
          'New Session with ' + widget.name,
          style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        CardContainer(
          child: Column(
            children: [
              const Text(
                'Set Session Length',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IncrementButton(icon: Icons.remove_circle_outline, tap: () {
                    setState(() {
                      int hours = selectedTime.hour;
                      int mins = selectedTime.minute - 5;
                      if (mins < 0) {
                        if (hours != 0) {
                          mins += 60;
                          hours -= 1;
                        } else {
                          mins = 0;
                        }
                      }
                      selectedTime = TimeOfDay(hour: hours, minute: mins);
                    });
                  },),
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: SizedBox(width: 60, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                        SizedBox(width: 20, child:
    Text("${selectedTime.hour.toString().padLeft(2,'0')}", textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 15.0))
                        ),
                        Text(' :'),
                        SizedBox(width: 20,child:Text(
                                // ((selectedTime.hour > 0) ? "${selectedTime.hour}h " : "") +
                                // "${selectedTime.minute}m",
                                "${selectedTime.minute.toString().padLeft(2,'0')}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 15.0),
                            )),
                         ]
                    )),
                    style: const ButtonStyle(),
                  ),
                  IncrementButton(
                      tap: () {
                        setState(() {
                          int hours = selectedTime.hour;
                          int mins = selectedTime.minute + 5;
                          if (mins >= 60) {
                            mins -= 60;
                            hours += 1;
                          }
                          selectedTime = TimeOfDay(hour: hours, minute: mins);
                        });
                      },
                      icon: Icons.add_circle_outline)
                ],
              ),
            ],
          )
        ),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        CardContainer(
          child: Column(
            children: [
              const Text(
                'Set Breaks',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _breaks = _breaks == 0 ? 0 : _breaks - 1;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        NumberPicker(
                          value: _breaks,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (value) => setState(() => _breaks = value),
                        );
                      });
                    },
                    child: Text(
                      _breaks.toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    style: const ButtonStyle(),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _breaks = _breaks + 1;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          )
        ),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(25),
          ),
          onPressed: () {
            if (selectedTime.hour == 0 && selectedTime.minute == 0) {
              sessionStartInfoDialog('Invalid session time',
                  'Please make sure you select a time before starting a session');
            } else if (!_userInSession) {
              print('starting session');
              database.startSession(
                  widget.uid,
                  widget.name,
                  Timestamp.now(),
                  selectedTime.hour,
                  selectedTime.minute,
                  _breaks);
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, true);
              sessionStartInfoDialog( widget.name + ' is unavailable',
                  widget.name + ' is already in a session! You\'ll have to try again later!');
            }
            //TODO else {} Need to indicate to the user that the other user is already in an active session
          },
          child: StreamBuilder<DocumentSnapshot?>(
              stream: database.getUserDocStream(widget.uid),
              initialData: null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Load();
                } else {
                  var otherUser = snapshot.data!.data() as Map<String, dynamic>;
                  _userInSession = otherUser['session_active'];
                  return Text(
                      'Start'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      )
                  );
                }
              }
          ),
        ),
        const Expanded(
          child: SizedBox(),
          flex: 3,
        ),
      ],
    );
  }

  sessionStartInfoDialog(String title, String content) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK')
            )
          ],
        )
    );
  }


  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: 'Set Session Length',
        hourLabelText: 'Hours',
        minuteLabelText: 'Minutes',
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}

class IncrementButton extends StatelessWidget {

  const IncrementButton(
      { Key? key,
        this.tap,
        this.longPress,
        required this.icon }
      ) : super(key: key);

  final void Function()? tap;
  final void Function()? longPress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: tap,
            onLongPress: longPress,
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(icon),
            )
        )
    );
  }
}
