import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Load extends StatelessWidget {
  const Load({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue[100],
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: SpinKitWanderingCubes(
          color: Colors.grey,
          size: 50.0,
        ),
      ),
    );
  }
}
