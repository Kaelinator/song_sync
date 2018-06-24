
import "package:flutter/material.dart";

import "dart:io";

import "./timestamp.dart";

class Song extends StatefulWidget {

  final List<Timestamp> drops;
  final String title;
  final File address;

  Song({this.title, this.address, this.drops});

  Song.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        address = json["address"],
        drops = json["drops"]
          .map<Timestamp>((dynamic v) => Timestamp.fromJson(v))
          .toList();

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
      drops: drops
    );
}

class SongState extends State<Song> {

  List<Timestamp> drops;
  String title;
  File address;

  SongState({this.title, this.address, this.drops});

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Text(title)
    );
  }
}