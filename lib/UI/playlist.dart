import "package:flutter/material.dart";
import "dart:io";

class Playlist extends StatelessWidget {

  final File jsonData;

  Playlist(this.jsonData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListTile(
      leading: const Icon(Icons.music_note),
      title: new Text(jsonData.path)
    );
  }
}
