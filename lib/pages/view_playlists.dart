import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart";
import "package:watcher/watcher.dart";

import "dart:io";
import "dart:async";

import "../UI/playlist_tile.dart";

import "./playlist_studio.dart";

class PlaylistPage extends StatefulWidget {

  PlaylistPage();

  @override
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  List<File> playlists = new List<File>();
  Directory playlistDir;
  DirectoryWatcher watcher;

  @override
  void initState() {
    super.initState();


    getApplicationDocumentsDirectory()
      .then(_setPlaylistDir)
      .then(_createAbsentDirectories)
      .then(readPlaylists)
      .whenComplete(() {

        watcher = new DirectoryWatcher(playlistDir.path);
        watcher.events.listen((WatchEvent event) {
          // if (event is )
          reloadPlaylists();
        });
      });
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

  void reloadPlaylists() {

    playlists = new List<File>();
    print("reloaded files");

    readPlaylists(playlistDir);
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

  File _newPlaylistFile() =>
    new File(join(playlistDir.path, "Playlist ${playlists.length}.json"));

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: Text("Playlists")
    ),
    body: new ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (BuildContext context, int index) {
        return new PlaylistTile(playlists[index]);
      }
    ),
    floatingActionButton: new FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.push(context,
        new MaterialPageRoute(
          builder: (context) => new PlaylistStudio(_newPlaylistFile())
        )
      ),
      tooltip: "Create a new playlist",
    ),
  );
}