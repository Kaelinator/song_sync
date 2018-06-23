import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart";

import "dart:io";
import "dart:async";
// import "dart:convert";

import "../UI/playlist.dart";
import "../UI/context_FAB.dart";

class PlaylistPage extends StatefulWidget {
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  List<File> playlists = new List<File>();
  File latestFile;
  Directory playlistDir;


  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory()
      .then(_setPlaylistDir)
      .then(_createAbsentDirectories)
      .then(readPlaylists);
    
  }

  Future<Directory> _setPlaylistDir(Directory dir) async {

    Directory newDir = new Directory(join(dir.path, "playlists"));

    setState(() => playlistDir = newDir);

    return newDir;
  }

  Future<Directory> _createAbsentDirectories(Directory dir) {
    return dir.exists()
      .then((isThere) => (isThere)
        ? dir
        : dir.create(recursive: true)
      );
  }

  void readPlaylists(Directory dir) {

    dir.list()
      .listen((FileSystemEntity entity) {
        if (entity is !File || extension(entity.path) != ".json")
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
    ),
    floatingActionButton: new ContextFAB(playlistDir),
  );
}