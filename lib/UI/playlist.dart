import "package:flutter/material.dart";
import "package:path/path.dart";

import "dart:io";
import "dart:async";

import "../pages/view_playlists.dart";

class Playlist extends StatefulWidget {

  final File playlistFile;

  Playlist(this.playlistFile);

  @override
  State createState() => new PlaylistState(playlistFile);
}

class PlaylistState extends State<Playlist> {

  File playlistFile;
  bool areOptionsOpen = false;
  // Map<String, String> jsonData = new Map<String, String>();

  PlaylistState(this.playlistFile);

  @override
  void initState() {
    super.initState();

  }

  Future<FileSystemEntity> backupAndDelete(BuildContext context) {
    // TODO: backup jsonData

    PlaylistPageState playlistView = context.ancestorStateOfType(
      const TypeMatcher<PlaylistPageState>(),
    );

    return playlistFile.delete()
      .whenComplete(() => playlistView.reloadPlaylists());
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.music_note),
      title: new Text(basenameWithoutExtension(playlistFile.path)),
      onLongPress: () => setState(() => areOptionsOpen = !areOptionsOpen),
      selected: areOptionsOpen,
      trailing: (areOptionsOpen) 
        ? new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: () => backupAndDelete(context)
            .then((FileSystemEntity f) {
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text("Deleted ${basenameWithoutExtension(f.path)}"),
                ));
              })
              .catchError((e) {
                print(e);
                Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    content: new Text("Failed to delete playlist."),
                  ));
              })
          )
        : null
    );
  }
}
