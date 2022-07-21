import 'package:flutter/cupertino.dart';

class TrackDetails {
  late String track_id;
  late String track_name;
  late String album_nmae;
  late String artist_name;

  TrackDetails(
      {this.track_id = "trackId",
      this.track_name = "name",
      this.album_nmae = "album",
      this.artist_name = "artist"});
  factory TrackDetails.fromMap(Map m) {
    return TrackDetails(
        track_id: m["track_id"].toString(),
        track_name: m["track_name"],
        album_nmae: m["album_name"],
        artist_name: m["artist_name"]);
  }
}
