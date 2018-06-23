
import "package:flutter/material.dart";

class EditPlaylist extends StatefulWidget {
  @override
  EditPlaylistState createState() => EditPlaylistState();
}

class EditPlaylistState extends State<EditPlaylist> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Playlist 1")
      ),
      body: new ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return new Text("Song $index");
      }
    ),
    );
  }
}