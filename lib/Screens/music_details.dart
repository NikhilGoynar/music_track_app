import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:music_track_app/Database/MemoDbprovider.dart';
import 'package:music_track_app/Database/memo_model.dart';
import 'package:provider/provider.dart';

import '../Providers/favorite_provider.dart';

class MusicDetail extends StatefulWidget {
  late String id;
  MusicDetail({required this.id});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail> {
  bool isloading = true;
  String name = "name";
  String Artist = "Artist";
  String AlbumName = "";
  String Explicit = "";
  String Rating = "";
  String Lyrics = "";
  GetData() async {
    String x = widget.id;
    int a = int.parse(x);
    try {
      Response response = await get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.get?track_id=$a&apikey=8eca0358ce45c6e6f199e724b5596f2d"));
      Map data = jsonDecode(response.body);
      setState(() {
        Map a = data["message"]["body"]["track"];
        name = a["track_name"];
        Artist = a["artist_name"];
        AlbumName = a["album_name"];
        Rating = a["track_rating"].toString();
        Explicit = a["explicit"].toString();
        isloading = false;
        if (Explicit == "0") {
          Explicit = "false";
        } else if (Explicit == "1") {
          Explicit = "true";
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Getlyrics() async {
    String x = widget.id;
    int a = int.parse(x);
    try {
      Response response = await get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$a&apikey=8eca0358ce45c6e6f199e724b5596f2d"));
      Map data = jsonDecode(response.body);
      setState(() {
        Lyrics = data["message"]["body"]["lyrics"]["lyrics_body"];
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  InsertSong() async {
    int a = int.parse(widget.id);
    MemoModel memoModel = MemoModel(
        id: a, track_name: name, Artist_name: Artist, albumname: AlbumName);
    MemoDbProvider inst = MemoDbProvider();
    await inst.addItem(memoModel);
  }
  // bool isMark = false;

  deleteSong() async {
    int a = int.parse(widget.id);
    MemoModel memoModel = MemoModel(
        id: a, track_name: name, Artist_name: Artist, albumname: AlbumName);
    MemoDbProvider inst = MemoDbProvider();
    await inst.deleteMemo(a);
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
    Getlyrics();
  }

  // bool isMark=false;
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Details"),
        actions: [
          Consumer<Manage>(builder: (context, provider, child) {
            int b = int.parse(widget.id);
            provider.makeList(b);
            
            return FavoriteButton(
              isFavorite: provider.isMark,
              // iconDisabledColor: Colors.white,
              valueChanged: (_isFavorite) {
                
                if (provider.isMark == false) {
                  provider.findId(b);
                  InsertSong();
                } else {
                  deleteSong();
                  provider.makeFalse();
                }
              },
            );
          }),
         
        ],
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$name",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Artist",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$Artist",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Album Name",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$AlbumName",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Explicit",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$Explicit",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rating",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$Rating",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lyrics",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "$Lyrics",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
