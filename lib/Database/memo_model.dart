class MemoModel {
  final int id;
  final String track_name;
  final String Artist_name;
  final String albumname;

  MemoModel(
      {required this.id,
      required this.track_name,
      required this.Artist_name,
      required this.albumname});

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "trackId": id,
      "trackName": track_name,
      "ArtistName": Artist_name,
      "AlbumName": albumname,
    };
  }
}
