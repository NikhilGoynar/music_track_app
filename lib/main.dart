import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_track_app/Providers/favorite_provider.dart';
import 'package:music_track_app/Screens/home_page.dart';
import 'package:bloc/bloc.dart';
import 'package:music_track_app/blocs/internet_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => InternetBloc(),
        child: MultiProvider(
          providers: [ChangeNotifierProvider.value(value: Manage())],
          child:
           MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyhomePage(),
          ),
        ));
  }
}
