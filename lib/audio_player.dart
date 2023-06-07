import 'package:audio_player_task/audio_player_controller.dart';
import 'package:audio_player_task/media_meta_data.dart';
import 'package:audio_player_task/position_data.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerClass extends StatelessWidget {
   AudioPlayerClass({Key? key}) : super(key: key);

   Stream<PositionData>get positionDataStream =>
    Rx.combineLatest3<Duration,Duration,Duration?,PositionData>(
       controller.audioPlayer.positionStream,
        controller.audioPlayer.bufferedPositionStream,
      controller.audioPlayer.durationStream,
        (position,bufferedPosition,duration)=>
            PositionData(position, bufferedPosition, duration?? Duration.zero)
    );
   AudioPlayerController controller=Get.put(AudioPlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration:const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            StreamBuilder(
                stream: controller.audioPlayer.sequenceStateStream,
                builder:(context,snapshot){
               final state=snapshot.data;
               if(state?.sequence.isEmpty??true){
                 return const SizedBox();
               }
               final metadata=state?.currentSource?.tag as MediaItem;
               return MediaMetaData(title: metadata.title, artist: metadata.artist??"",image: metadata.artUri.toString()??"",);
            }),

            // ListView.builder(
            //     itemCount: controller.playList.value.children.length,
            //     itemBuilder:(context,index){
            //      return MediaMetaData(title:controller.playList.value.children[index]. , artist: artist)
            // })
            
            
            StreamBuilder<PositionData>(stream:positionDataStream,
             builder: (context,snapshot){
               final positionData=snapshot.data;
               return ProgressBar(
                 barHeight: 8,
                 baseBarColor: Colors.grey[600],
                 bufferedBarColor: Colors.grey,
                 progressBarColor: Colors.red,
                 thumbColor: Colors.red,
                 timeLabelTextStyle: TextStyle(
                    color: Colors.white,
                   fontWeight: FontWeight.w600,
                 ),
                 progress: positionData?.position ?? Duration.zero,
                 buffered: positionData?.bufferedPosition ?? Duration.zero,
                 total:positionData?.duration??Duration.zero,
                 onSeek: controller.audioPlayer.seek,
               );
             },
            ),
            ControlButtons(player:controller.audioPlayer )
          ],
        ),
      ),

    );
  }
}
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed:()=>player.seekToPrevious(), icon: Icon(Icons.skip_previous_rounded,size: 60,color: Colors.white,)),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(onPressed: player.play,
                  icon: const Icon(
                    Icons.play_arrow_rounded, color: Colors.white, size: 80,));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(onPressed: player.pause,
                  icon: const Icon(
                    Icons.pause_rounded, color: Colors.white, size: 80,));
            }
            return IconButton(onPressed: player.play,
                icon: const Icon(
                  Icons.play_arrow_rounded, color: Colors.white, size: 80,));
          }
        ),
        IconButton(onPressed:()=>player.seekToNext(), icon: Icon(Icons.skip_next_rounded,size: 60,color: Colors.white,)),

      ],
    );
  }
}
