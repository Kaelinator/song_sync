
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:audioplayers/audioplayer.dart";

import "dart:io";
import "dart:convert";

import "../UI/song.dart";

class Player extends StatefulWidget {

  final File playlistFile;

  Player(this.playlistFile);

  @override
  PlayerState createState() => PlayerState(
    basenameWithoutExtension(playlistFile.path),
    playlistFile
  );
}

class PlayerState extends State<Player> {

  final String name;
  final File playlistFile;
  List<Song> playlist;
  AudioPlayer player;

  PlayerState(this.name, this.playlistFile);

  @override
  void initState() {
    
    player = new AudioPlayer();

    playlistFile.exists()
          .then((bool isThere) {
            if (!isThere)
              return null;
            
            return playlistFile.readAsString()
              .then((String data) {
                
                print(data);

                List<Song> decoded = json.decode(data)
                  .map<Song>((dynamic v) => Song.fromJson(v))
                  .toList();

                setState(() {
                  playlist = decoded;
                });
              });
          })
          .whenComplete(() => player.play(playlist[0].address.path, isLocal: true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name)
      )
    );
  }
}
