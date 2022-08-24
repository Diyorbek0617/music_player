import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'about.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);
  static const String id = "MusicPlayer";

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  bool isPlaying=false;
  double value=0;
  final player = AudioPlayer();

  Duration? duration=const Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(
      AssetSource("audio/xamdamSobirov.mp3"),
    );
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Music Player"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              About(context);
            },
            icon: const Icon(Icons.perm_device_info),
          ),
        ],
      ),
      body: Stack(
        children: [
          // background image
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/xamdamSobirov.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.white24,
              ),
            ),
          ),
          //foreground body
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/image/xamdamSobirov.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Xamdam Sobirov",
                style: TextStyle(
                    color: Colors.white, fontSize: 30.0, letterSpacing: 6),
                softWrap: false,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value/60).floor()}:${(value % 60).floor()}",
                    style:const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Slider.adaptive(
                      min: 0.0,
                      max: duration!.inSeconds.toDouble(),
                      value: value,
                      inactiveColor: Colors.white,
                      activeColor: Colors.green,
                      onChanged: (v) {
                        setState((){
                          if(v==duration!.inSeconds.toDouble()){
                            isPlaying=false;
                          }
                          value=v;
                        });
                      },
                      onChangeEnd: (nV)async{
                        setState((){
                          value=nV;
                          isPlaying=true;
                        });
                        player.pause();
                        await player.seek(Duration(seconds: nV.toInt()));
                        await player.resume();
                      },
                    ),
                  ),
                  Text(
                    "${duration!.inMinutes}: ${duration!.inSeconds % 60}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 45.0,
                    color: Colors.black,
                    onPressed: (){},
                    icon: const Icon(Icons.skip_previous),
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(width: 1, color: Colors.red),
                    ),
                    child: InkWell(
                      onTap: ()async{
                        if(isPlaying){
                          await player.pause();
                          setState((){
                            isPlaying= false;
                          }
                          );

                        }else {
                          await player.resume();
                          setState((){
                            isPlaying=true;
                          });

                          player.onPositionChanged.listen((position) {
                            setState(() {
                              value = position.inSeconds.toDouble();
                            });
                          });
                        }

    },
                      child: Icon(
                        isPlaying?Icons.pause:Icons.play_arrow,color: Colors.white,),
                    ),
                  ),

                  IconButton(
                    iconSize: 45.0,
                    color: Colors.black,
                    onPressed: (){},
                    icon: const Icon(Icons.skip_next),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
