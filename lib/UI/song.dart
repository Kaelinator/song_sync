
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";

import "dart:io";

import "./timestamp.dart";
import "../pages/playlist_studio.dart";

typedef void UpdateSongCallback(SongState song);
typedef void DeleteSongCallback(String id);

class Song extends StatefulWidget {

  final List<Timestamp> drops;
  final String title;
  final File address;
  final String id;
  final UpdateSongCallback update;
  final DeleteSongCallback delete;

  Song({this.title, this.address, this.drops, this.id, this.update, this.delete});

  Song.fromJson(Map<String, dynamic> json, {this.update, this.delete})
      : title = json["title"],
        address = new File(json["address"]),
        drops = json["drops"]
          .map<Timestamp>((dynamic v) => Timestamp.fromJson(v))
          .toList(),
        id = new Uuid().v4();

  Map<String, dynamic> toJson() =>
    {
      "title": title,
      "address": address?.path ?? null,
      "drops": (drops ?? []).toList()
    };

  int nextDrop(int positionSec) {

    return drops
      .map((Timestamp t) => (t.toSeconds() - positionSec).round())
      .firstWhere((int dist) => dist > 0, orElse: () => -1);
  }

  @override
  SongState createState() => SongState(
      title: title,
      address: address,
      drops: drops,
      id: id,
      update: update,
      delete: delete
    );
}

class SongState extends State<Song> {

  List<Timestamp> drops;
  String title;
  File address;
  bool fileExists = false;
  String id;
  PlaylistStudioState playlistView;
  final UpdateSongCallback update;
  final DeleteSongCallback delete;

  SongState({this.title, this.address, this.drops, this.id, this.update, this.delete});

  void remove(BuildContext context) {
    
    delete(id);
  }

  void timestampsChange(String text, BuildContext context) {

    List<Timestamp> newDrops = text
      .split(";")
      .map((String s) => new Timestamp.fromString(s))
      .toList();

    setState(() {
      drops = newDrops;
    });
  }

  void fileChange(String text, BuildContext context) {

    getExternalStorageDirectory()
      .then((Directory directory) {

        File newAddress = new File(join(directory.path, "Music", text));

        newAddress.exists()
          .then((isThere) {
            if (!isThere)
              return;
            
            address = newAddress;

            setState(() {
              fileExists = isThere;
              title = basenameWithoutExtension(address.path);
            });
          });
    });
  }

  @override
  void dispose() {

    update(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.music_note),
            title: new Text(title)
          ),
          const Text("File location:"),
          new TextField(
            onChanged: (String text) => fileChange(text, context),
            style: new TextStyle(
              color: (fileExists) ? Colors.black : Colors.red
            )
          ),
          const Text("Drop timestamps:"),
          new TextField(
            onChanged: (String text) => timestampsChange(text, context),
          ),
          new ButtonTheme.bar(
            child: new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text("Delete"),
                  onPressed: () => remove(context)
                )
              ],
            )
          )
        ],
      )
      
    );
  }
}