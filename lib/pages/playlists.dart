import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";
import "dart:async";

import "../UI/playlist.dart";

class PlaylistPage extends StatefulWidget {
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  // Directory _playlistsDir;
  List<File> playlists = new List<File>();

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory()
      .then(createAbsentDirectories)
      .then(setPlaylistPaths);
      // .then((Directory dir) =>
      //   setState(() => _playlistsDir = dir)
      // );
  }

  Future<Directory> createAbsentDirectories(Directory dir) {
    return dir.exists()
      .then((isThere) => (isThere)
        ? dir
        : dir.create(recursive: true)
      );
  }

  void setPlaylistPaths(Directory dir) {

    dir.list()
      .listen((FileSystemEntity entity) {
        if (entity is !File)
          return;

        List<File> newPlaylists = List.from(playlists);
        newPlaylists.add(entity);

        setState(() => playlists = newPlaylists);
      });
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: Text("Playlists")
    ),
    body: new ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (BuildContext context, int index) {
        return new Playlist(playlists[index]);
      }
    )
  );
}