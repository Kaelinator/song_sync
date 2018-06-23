
import "dart:io";

class Song {
  
  List<Duration> drops = new List<Duration>();
  String name;
  File address;

  Song(this.name, this.address, this.drops);

}
