import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;

  // Future<void> playSong(int index) async {
  //   if (isPlaying) {
  //     // print('Pausing song at index: $index');
  //     _isPlaying.value = false;
  //     await audioPlayer.pause();
  //   } else {
  //     // if (currentIndex != index) {
  //     //   print('Setting new audio source for index: $index');
  //     //   try {
  //     //     await audioPlayer.setAudioSources(
  //     //       songs.map((song) {
  //     //         return AudioSource.uri(Uri.parse(song.uri!));
  //     //       }).toList(),
  //     //       initialIndex: index,
  //     //       initialPosition: Duration.zero,
  //     //     );
  //     //     ref.read(currentSongIndexProvider.notifier).state = index;
  //     //   } catch (e) {
  //     //     return;
  //     //   }
  //     // }
  //     print('Playing song at index: $index');
  //     _isPlaying.value = true;
  //     await audioPlayer.play();
  //   }
  // }
}
