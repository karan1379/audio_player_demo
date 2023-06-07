import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends GetxController{
  late AudioPlayer audioPlayer;


  var playList=ConcatenatingAudioSource(children:[
      AudioSource.asset("assets/audio/nature.mp3",tag:  MediaItem(
          id: '1', title: 'nature',artist: 'New Artist',
          artUri: Uri.parse("https://fastly.picsum.photos/id/345/200/300.jpg?hmac=_qOjrd4yW7rtmkQN1PgF8hczgXJezqk92MxgRUzB06s")

      )),
    AudioSource.asset("assets/audio/nature.mp3",tag:MediaItem(
      id: '2', title: 'nature',artist: 'New Artist 2',
  artUri: Uri.parse("https://fastly.picsum.photos/id/345/200/300.jpg?hmac=_qOjrd4yW7rtmkQN1PgF8hczgXJezqk92MxgRUzB06s")
  )),
    AudioSource.asset("assets/audio/nature.mp3",tag:MediaItem(
      id: '3', title: 'nature',artist: 'New Artist 3',
        artUri: Uri.parse("https://fastly.picsum.photos/id/345/200/300.jpg?hmac=_qOjrd4yW7rtmkQN1PgF8hczgXJezqk92MxgRUzB06s")



    )),
   ]).obs;

  Future initPlayList() async{
     await audioPlayer.setLoopMode(LoopMode.all);
     await audioPlayer.setAudioSource(playList.value);
  }

  @override
  void onInit() {
    audioPlayer=AudioPlayer();
    // audioPlayer.setAsset("assets/audio/nature.mp3");
    initPlayList();
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onClose() {
    audioPlayer.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}