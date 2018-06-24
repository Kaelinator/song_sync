import "package:flutter/material.dart";
import "package:path/path.dart";

import "dart:io";

import "../pages/playlist_studio.dart";

class PlaylistTile extends StatelessWidget {

  final File playlistFile;

  PlaylistTile(this.playlistFile);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.music_note),
      title: new Text(basenameWithoutExtension(playlistFile.path)),
      onLongPress: () => Navigator.push(context,
        new MaterialPageRoute(
          builder: (context) => new PlaylistStudio(playlistFile)
        )
      ),
    );
  }
}
