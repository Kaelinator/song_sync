import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.purple[100],
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("It works!"),
            new Text("Don't forget to subscribe!"),
            new FloatingActionButton(
                onPressed: () => print("yep!"),
                child: new Icon(Icons.track_changes))
          ],
        ));
  }
}
