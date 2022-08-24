import 'package:flutter/material.dart';
import 'package:music_player/musicPlayer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MusicPlayer(),
      routes: {
        MusicPlayer.id:(context)=>const MusicPlayer(),
      },
    );
  }
}
