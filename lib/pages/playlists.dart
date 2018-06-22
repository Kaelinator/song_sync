import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";

import "../UI/playlist.dart";

class PlaylistPage extends StatefulWidget {
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  Directory _playlistsDir;

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory()
      .then((Directory dir) =>
        setState(() => _playlistsDir = dir)
      );
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: Text("Playlists")
    ),
    body: new ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return new Playlist("${_playlistsDir?.path} $index");
      }
    )
  );
}