import "package:flutter/material.dart";

class Playlist extends StatelessWidget {

  final String title;

  Playlist(this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListTile(
      leading: const Icon(Icons.event_seat),
      title: new Text(this.title),
    );
  }
}
