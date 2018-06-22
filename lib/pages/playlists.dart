import "package:flutter/material.dart";

class PlaylistPage extends StatefulWidget {
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: Text("Playlists")
    )
  );
}
