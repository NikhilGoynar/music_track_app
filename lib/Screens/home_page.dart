import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:music_track_app/Screens/favorites_tracks.dart';
import 'package:music_track_app/Screens/music_details.dart';
import 'package:music_track_app/blocs/internet_bloc.dart';
import 'package:music_track_app/blocs/internet_state.dart';
import 'package:music_track_app/models/models.dart';

class MyhomePage extends StatefulWidget {
  const MyhomePage({Key? key}) : super(key: key);

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  late int id;
  bool isloading = true;
  List<TrackDetails> trackdetails = [];
  getDetails() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=8eca0358ce45c6e6f199e724b5596f2d"));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body.toString());

        Map x = data["message"];

        Map y = x["body"];

        List a = y["track_list"];

        setState(() {
          isloading = false;
          a.forEach((element) {
            Map b = element["track"];

            TrackDetails instance = new TrackDetails();
            instance = TrackDetails.fromMap(b);
            // print(instance);
            trackdetails.add(instance);
          });
        });

        // print(a.length);

      } else {
        print("Error Nikhil bhai");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trending"),
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => FavoriteTracks())));
                },
                child: Icon(Icons.bookmark)),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: Center(child: BlocBuilder<InternetBloc, InternetState>(
          builder: ((context, state) {
            if (state is InternetGainedState) {
              return isloading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: trackdetails.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MusicDetail(
                                            id: trackdetails[index].track_id)));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: ListTile(
                                  leading: Icon(Icons.library_music),
                                  title: Text(trackdetails[index].track_name),
                                  subtitle:
                                      Text(trackdetails[index].album_nmae),
                                  trailing:
                                      Text(trackdetails[index].artist_name),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  color: Colors.grey,
                                )),
                          ],
                        );
                      });
            } else if (state is InternetLostState) {
              return Text("No Intenet Connection");
            } else {
              return Text("Loading...");
            }
          }),
        )));
  }
}
