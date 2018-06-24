
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import "dart:io";

import "./timestamp.dart";
import "../pages/playlist_studio.dart";

class Song extends StatefulWidget {

  final List<Timestamp> drops;
  final String title;
  final File address;
  final String id;

  Song({this.title, this.address, this.drops, this.id});

  Song.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        address = json["address"],
        drops = json["drops"]
          .map<Timestamp>((dynamic v) => Timestamp.fromJson(v))
          .toList(),
        id = new Uuid().v4();

  Map<String, dynamic> toJson() =>
    {
      "title": title,
      "address": address,
      "drops": (drops ?? []).toList()
    };

  @override
  SongState createState() => SongState(
      title: title,
      address: address,
      drops: drops,
      id: id
    );
}

class SongState extends State<Song> {

  List<Timestamp> drops;
  String title;
  File address;
  String id;

  SongState({this.title, this.address, this.drops, this.id});

  void remove(BuildContext context) {
    PlaylistStudioState playlistView = context.ancestorStateOfType(
      const TypeMatcher<PlaylistStudioState>(),
    );

    playlistView.deleteSong(id);
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.album),
      title: new Text(title),
      trailing: new IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => remove(context),
      )
    );
  }
}