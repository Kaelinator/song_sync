
import "dart:io";

class Song {
  
  List<Duration> drops = new List<Duration>();
  String title;
  File address;

  Song({this.title, this.address, this.drops});

  Song.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        address = json['address'],
        drops = json['drops'];

  Map<String, dynamic> toJson() =>
    {
      'title': title,
      'address': address,
      'drops': drops
    };
}
