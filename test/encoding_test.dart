import 'package:flutter_test/flutter_test.dart';

import "dart:convert";

import "../lib/UI/song.dart";
import "../lib/UI/timestamp.dart";

void main() {
  test("Encodes Song lists", () {
    
    List<Song> playlist = [
      new Song(title: "Blame"),
      new Song(title: "Lean On"),
      new Song(title: "Try Everything")
    ];

    String encoded = json.encode(playlist);

    String expected = 
      r'['
        '{"title":"Blame","address":null,"drops":[]},'
        '{"title":"Lean On","address":null,"drops":[]},'
        '{"title":"Try Everything","address":null,"drops":[]}'
      ']';

    expect(encoded, expected);
  });

  test("Encodes Song drop Duration list", () {
    
    List<Song> playlist = [
      new Song(
        title: "Blame",
        drops: <Timestamp>[
          new Timestamp(seconds: 3),
          new Timestamp(seconds: 55)
        ]
      ),
    ];

    String encoded = json.encode(playlist);

    String expected = 
      r'['
        '{"title":"Blame","address":null,"drops":['
          '{"minutes":0,"seconds":3,"milliseconds":0},'
          '{"minutes":0,"seconds":55,"milliseconds":0}'
        ']}'
      ']';

    expect(encoded, expected);
  });
}
