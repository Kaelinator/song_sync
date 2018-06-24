
import "package:flutter/material.dart";
import "package:path/path.dart";

import "dart:io";
import "dart:async";
import "dart:convert";

import "../util/song.dart";
import "../pages/view_playlists.dart";
import "../UI/song_tile.dart";

class PlaylistStudio extends StatefulWidget {

  final File index;

  PlaylistStudio(this.index);

  @override
  PlaylistStudioState createState() => PlaylistStudioState(index);
}

class PlaylistStudioState extends State<PlaylistStudio> {

  String name;
  File index;
  List<Song> playlist = new List<Song>();

  PlaylistStudioState(this.index) {
    name = basenameWithoutExtension(index.path);
  }

  @override
  void initState() {
    super.initState();

    index.exists()
      .then((bool isThere) {
        if (!isThere)
          return;
        
        index.readAsString()
          .then((String data) => json.decode(data));
      });
  }

  @override
  void dispose() {
    // TODO: save JSON data

    super.dispose();
  }

  Future<File> createFile() {

    print("Creating file!");

    return index.exists()
      .then((bool isThere) => isThere ? index.create() : Future.value(index))
      .then((File file) => file.writeAsString("Just a test!"));
  }

  void createSong() {

    List<Song> newPlaylist = List.from(playlist);

    newPlaylist.add(new Song(
      title: "Song 1"
    ));

    setState(() {
      playlist = newPlaylist;
    });
  }

  Future<FileSystemEntity> backupAndDelete(BuildContext context) {
    // TODO: backup jsonData for undo

    PlaylistPageState playlistView = context.ancestorStateOfType(
      const TypeMatcher<PlaylistPageState>(),
    );

    return index.delete()
      .whenComplete(() => playlistView.reloadPlaylists())
      .whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () => Navigator.pop(context)
          ),
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () => backupAndDelete(context)
          )
        ],
      ),
      body: new ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (BuildContext context, int index) {
          return new SongTile(playlist[index]);
        }
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        tooltip: "Add a song",
        onPressed: createSong,
      ),
    );
  }
}