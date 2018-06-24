
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:uuid/uuid.dart";

import "dart:io";
import "dart:async";
import "dart:convert";

import "../UI/song.dart";

class PlaylistStudio extends StatefulWidget {

  final File index;

  PlaylistStudio(this.index);

  @override
  PlaylistStudioState createState() => PlaylistStudioState(index);
}

class PlaylistStudioState extends State<PlaylistStudio> {

  String name;
  File index;
  bool deleting = false; // it was recreating it in the dispose method, temp fix
  List<Song> playlist = new List<Song>();

  PlaylistStudioState(this.index) {
    name = basenameWithoutExtension(index.path);
  }

  void deleteSong(String id) {

    List<Song> newList = List.from(playlist);

    int index = newList.indexWhere((Song s) => s.id == id);
    if (index == -1)
      return;

    newList.removeAt(index);

    setState(() {
      playlist = newList;
    });
  }

  void updateSong(SongState songData) {
    
    List<Song> newList = List.from(playlist);

    int index = newList.indexWhere((Song s) => s.id == songData.id);
    if (index == -1)
      return;

    newList[index] = new Song(
      title: songData.title,
      address: songData.address,
      drops: songData.drops
    );

    print("playlist updated! ${songData.title}");

    setState(() {
      playlist = newList;
    });
  }

  @override
  void initState() {
    super.initState();

    index.exists()
      .then((bool isThere) {
        if (!isThere)
          return;
        
        index.readAsString()
          .then((String data) {
            
            print(data);

            List<Song> decoded = json.decode(data)
              .map<Song>((dynamic v) => Song.fromJson(v))
              .toList();

            setState(() {
              playlist = decoded;
            });
          });
      });
  }

  @override
  void dispose() {

    if (!deleting)
      createFile();

    super.dispose();
  }

  Future<File> createFile() {

    print("Creating file!");

    return index.exists()
      .then((bool isThere) => isThere ? index.create() : Future.value(index))
      .then((File file) => file.writeAsString(json.encode(playlist)))
      .whenComplete(() => print("file written!"));
  }

  void createSong() {

    List<Song> newPlaylist = List.from(playlist);

    newPlaylist.add(new Song(
      title: "Song ${playlist.length}",
      id: new Uuid().v4()
    ));

    setState(() {
      playlist = newPlaylist;
    });
  }

  Future<FileSystemEntity> backupAndDelete(BuildContext context) {
    // TODO: backup jsonData for undo
      
    deleting = true; // temp fix

    return index.delete()
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
          return playlist[index];
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