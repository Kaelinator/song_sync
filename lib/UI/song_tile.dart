
import "package:flutter/material.dart";

import "../util/song.dart";

class SongTile extends StatefulWidget {

  final Song songData;

  SongTile(this.songData);

  @override
  SongTileState createState() => SongTileState(songData);
}

class SongTileState extends State<SongTile> {

  Song songData;

  SongTileState(this.songData);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Text(songData.title)
    );
  }
}