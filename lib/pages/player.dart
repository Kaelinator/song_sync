
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:audioplayers/audioplayer.dart";

import "dart:io";
import "dart:convert";
import "dart:async";

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
  AudioPlayer mainChannel;
  // AudioPlayer fadeChannel;

  int songIndex = 0;
  double songProgress = 0.0;
  bool playing = false;
  int duration = 0;
  int tMinus = 0;

  PlayerState(this.name, this.playlistFile);

  @override
  void initState() {

    AudioPlayer.logEnabled = false;
    
    mainChannel = new AudioPlayer();
    // fadeChannel = new AudioPlayer();

    mainChannel.setDurationHandler((Duration d) => setState(() {
      duration = d.inSeconds;
    }));

    mainChannel.setPositionHandler((Duration d) {
      setState(() {
        songProgress = d.inSeconds / duration;
        tMinus = playlist[songIndex].nextDrop(d.inSeconds);
      });
    });

    mainChannel.setCompletionHandler(() => skip(1));

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
      .whenComplete(() => skip(0));

    super.initState();
  }

  @override
  void dispose() {

    mainChannel.stop();
    // fadeChannel.stop();

    super.dispose();
  }

  Future<int> skip(int moveBy) {

    int i = (songIndex + moveBy) % playlist.length;
    print("new Index: $i");

    return mainChannel.stop()
      .then((int result) {

        if (result == 0)
          return result;

        return mainChannel.play(playlist[i].address.path, isLocal: true)
          .then((int result) {
            if (result == 1)
              setState(() {
                songIndex = i;
                playing = true;
              });
            return result;
          });
      });

  }

  void togglePlaying() {

    bool isPlaying = !playing;

    if (isPlaying) {
      double prevProgress = songProgress;

      mainChannel.play(playlist[songIndex].address.path, isLocal: true)
        .then((result) {
          if (result == 0)
            return;
          
          seek(prevProgress);

          setState(() {
            playing = isPlaying;
          });
        });
      return;
    }

    mainChannel.pause()
      .then((result) {
        if (result == 1) {
          setState(() {
            playing = isPlaying;
          });
        }
      });
  }

  void seek(double percent) {
    
    mainChannel.seek(percent * duration);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name)
      ),
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(
              top: 36.0,
              bottom: 36.0
            ),
            child: new Text(
              (playlist != null) ? playlist[songIndex].title : "",
              style: const TextStyle(
                fontSize: 18.0
              )
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              new IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => skip(-1),
                iconSize: 64.0
              ),
              new IconButton(
                onPressed: togglePlaying,
                icon: (playing) ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                iconSize: 96.0
              ),
              new IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => skip(1),
                iconSize: 64.0
              )
            ]
          ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(
                  left: 8.0
                ),
                child: new Text(
                  new Duration(
                    seconds: (songProgress * duration).round()
                  ).toString()
                  .substring(3, 7)
                ),
              ),
              new Expanded(
                child:new Slider(
                  value: songProgress,
                  min: 0.0,
                  max: 1.0,
                  onChanged: seek
                )
              ),
              new Container(
                padding: EdgeInsets.only(
                  right: 8.0
                ),
                child: new Text(
                  new Duration(
                    seconds: (duration - songProgress * duration).round()
                  ).toString()
                  .substring(3, 7)
                ),
              )
            ],
          ),
          new Container(
            padding: EdgeInsets.only(
              top: 50.0
            ),
            child: new RaisedButton(
              color: Colors.redAccent,
              onPressed: () => print("skip to drop"),
              padding: EdgeInsets.all(32.0),
              child: const Text(
                "Hop to next drop",
                style: const TextStyle(fontSize: 32.0)
              )
            ),
          ),
          new Container(
            padding: EdgeInsets.only(
              top: 16.0,
              bottom: 16.0
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Text(
                    "T-Minus",
                    style: const TextStyle(
                      fontSize: 48.0
                    )
                  )
                ),
                new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Text(
                    "$tMinus",
                    style: const TextStyle(
                      fontSize: 64.0,
                      fontWeight: FontWeight.bold
                    )
                  )
                )
              ],
            )
          )
        ],
      )
    );
  }
}
