import 'package:flutter/material.dart';

class PushNav {
  void pushNavigation(BuildContext context, Widget dialog, bool fullscreen) {
    Navigator.push(context,
        MaterialPageRoute(
          builder: (BuildContext context) => dialog,
          fullscreenDialog: fullscreen,
        )
    );
  }
}
