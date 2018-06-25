
import "package:flutter/material.dart";

class Timestamp extends StatefulWidget {

  final int minutes;
  final int seconds;
  final int milliseconds;

  Timestamp({this.minutes, this.seconds, this.milliseconds});

  Timestamp.fromString(String time)
    : minutes = int.parse(time.split(":")[0]) ?? 0,
      seconds = int.parse(time.split(":")[1]) ?? 0,
      milliseconds = int.parse(time.split(":")[2]) ?? 0;

  Timestamp.fromJson(Map<String, dynamic> json)
      : minutes = json["minutes"] ?? 0,
        seconds = json["seconds"] ?? 0,
        milliseconds = json["milliseconds"] ?? 0;

  Map<String, dynamic> toJson() =>
    {
      "minutes": minutes ?? 0,
      "seconds": seconds ?? 0,
      "milliseconds": milliseconds ?? 0
    };

  double toSeconds() {
    return minutes * 60 + seconds + milliseconds * 0.001;
  }

  @override
  TimestampState createState() => TimestampState();
}

class TimestampState extends State<Timestamp> {

  int minutes;
  int seconds;
  int milliseconds;

  TimestampState({this.minutes, this.seconds, this.milliseconds});

  @override
  Widget build(BuildContext context) {
    return new Text("$minutes:$seconds:$milliseconds");
  }
}
