
import "package:flutter/material.dart";
import "package:secure_string/secure_string.dart";
import "package:path/path.dart";

import "dart:io";
import "dart:async";

class ContextFAB extends StatelessWidget {

  final Directory playlistDir;

  ContextFAB(this.playlistDir);

  Future<File> createFile() {

    print("Creating file!");

    String name = new SecureString().generateAlphabetic(length: 16);

    return new File(join(playlistDir.path, "$name.json"))
      .create()
      .then((file) => file.writeAsString("Just a test!")
        .then((file) => file));
      // .catchError((error) => setState());
  }

  @override
    Widget build(BuildContext context) {
      
      return new FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => createFile()
          .then((File f) {
            Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: new Text("Successfully created ${basenameWithoutExtension(f.path)}"),
              ));
          })
          .catchError((e) {
            print(e);
            Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: new Text("Failed to create playlist."),
              ));
          }),
      );
    }

}

