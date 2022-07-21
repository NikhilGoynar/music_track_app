import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:music_track_app/Database/MemoDbprovider.dart';

class FavoriteTracks extends StatefulWidget {
  const FavoriteTracks({Key? key}) : super(key: key);

  @override
  State<FavoriteTracks> createState() => _FavoriteTracksState();
}

class _FavoriteTracksState extends State<FavoriteTracks> {
  List maps = [];
  getQuery() async {
    MemoDbProvider memoDbProvider = MemoDbProvider();
    List l = await memoDbProvider.query();
    setState(() {
      maps = l;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Tracks")),
      body: ListView.builder(
          itemCount: maps.length,
          itemBuilder: (context, index) {
            return Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.library_music),
                  title: Text(maps[index]["trackName"]),
                  subtitle: Text(maps[index]["AlbumName"]),
                  trailing: Text(maps[index]["ArtistName"]),
                ),
              ),
            );
          }),
    );
  }
}
