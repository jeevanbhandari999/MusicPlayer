import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controllers/shuffle_order_loop_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class AudioService {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  final WidgetRef ref;
  final ShuffleOrderLoopController shuffleOrderLoopController =
      Get.find<ShuffleOrderLoopController>();
  Timer? _sleepTimer;

  AudioService(this.ref) {
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index != ref.read(currentSongIndexProvider)) {
        ref.read(currentSongIndexProvider.notifier).state = index;
        ref.read(isPlayingProvider.notifier).state = audioPlayer.playing;
      }
    });
  }

  Future<void> fetchSongs() async {
    List<SongModel> songs = await onAudioQuery.querySongs();
    songs =
        songs
            .where((song) => song.uri != null && song.uri!.isNotEmpty)
            .toList();
    if (songs.isEmpty) {
      return;
    }
    ref.read(songsProvider.notifier).state = songs;
    try {
      await audioPlayer.setAudioSources(
        songs.map((song) {
          return AudioSource.uri(Uri.parse(song.uri!));
        }).toList(),
      );
    } catch (e) {
      return;
    }
  }

  Future<void> playSong(int index) async {
    final currentIndex = ref.read(currentSongIndexProvider);
    final isPlaying = ref.read(isPlayingProvider);
    final songs = ref.read(songsProvider);
    if (songs.isEmpty) {
      return;
    }
    if (currentIndex == index && isPlaying) {
      ref.read(isPlayingProvider.notifier).state = false;
      await audioPlayer.pause();
    } else {
      if (currentIndex != index) {
        try {
          await audioPlayer.setAudioSources(
            songs.map((song) {
              return AudioSource.uri(Uri.parse(song.uri!));
            }).toList(),
            initialIndex: index,
            initialPosition: Duration.zero,
          );
          ref.read(currentSongIndexProvider.notifier).state = index;
        } catch (e) {
          return;
        }
      }
      ref.read(isPlayingProvider.notifier).state = true;
      await audioPlayer.play();
    }
  }

  Future<void> playNext() async {
    final songs = ref.read(songsProvider);
    final currentIndex = ref.read(currentSongIndexProvider);
    if (shuffleOrderLoopController.isLoop) {
      await playLoop();
    } else if (shuffleOrderLoopController.isShuffle) {
      await playShuffle();
    } else {
      if (currentIndex != null && currentIndex < songs.length - 1) {
        await audioPlayer.seekToNext();
        final newIndex = currentIndex + 1;
        ref.read(currentSongIndexProvider.notifier).state = newIndex;
        ref.read(isPlayingProvider.notifier).state = true;
        await audioPlayer.play();
      }
    }
  }

  Future<void> playPrevious() async {
    final currentIndex = ref.read(currentSongIndexProvider);
    if (shuffleOrderLoopController.isLoop) {
      await playLoop();
    } else if (shuffleOrderLoopController.isShuffle) {
      await playShuffle();
    } else {
      if (currentIndex != null && currentIndex > 0) {
        await audioPlayer.seekToPrevious();
        final newIndex = currentIndex - 1;
        ref.read(currentSongIndexProvider.notifier).state = newIndex;
        ref.read(isPlayingProvider.notifier).state = true;
        await audioPlayer.play();
      }
    }
  }

  Future<void> playShuffle() async {
    final songs = ref.read(songsProvider);
    final currentIndex = ref.read(currentSongIndexProvider);
    if (songs.isNotEmpty) {
      final random = Random();
      int newIndex;
      do {
        newIndex = random.nextInt(songs.length);
      } while (newIndex == currentIndex);
      try {
        await audioPlayer.setAudioSources(
          songs.map((song) {
            return AudioSource.uri(Uri.parse(song.uri!));
          }).toList(),
          initialIndex: newIndex,
          initialPosition: Duration.zero,
        );
        ref.read(currentSongIndexProvider.notifier).state = newIndex;
      } catch (e) {
        return;
      }
      ref.read(currentSongIndexProvider.notifier).state = newIndex;
      ref.read(isPlayingProvider.notifier).state = true;
      await audioPlayer.play();
    }
  }

  Future<void> playLoop() async {
    final currentIndex = ref.read(currentSongIndexProvider);
    if (currentIndex != null) {
      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.play();
          // print('Loop mode: song restarted automatically');
        }
      });
      await audioPlayer.play();
    }
  }

  bool get isSleepTimerActive => _sleepTimer != null;

  int get sleepTimerRemainingSeconds {
    if (_sleepTimer == null) return 0;
    final remaining = _sleepTimer!.tick;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> startSleepTimer(int seconds) async {
    print('Sleep Timer Start :::::: $seconds');
    _cancelSleepTimer();
    _sleepTimer = Timer(Duration(seconds: seconds), () {
      audioPlayer.stop();
      ref.read(isPlayingProvider.notifier).state = false;
      _sleepTimer = null;
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  Future<void> deleteSong(int songId) async {
    // print('deleted');
    if (!await Permission.storage.request().isGranted) {
      throw Exception('Storage permission denied');
    }
    await fetchSongs();

    final currentIndex = ref.read(currentSongIndexProvider);
    if (currentIndex != null &&
        ref.read(songsProvider)[currentIndex].id == songId) {
      await audioPlayer.stop();
      ref.read(currentSongIndexProvider.notifier).state = null;
      ref.read(isPlayingProvider.notifier).state = false;
    }
  }

  Future<void> updateSongTitle(int songId, String newTitle) async {
    if (!await Permission.storage.request().isGranted) {
      throw Exception('Storage permission denied');
    }
    await fetchSongs();
  }

  void dispose() {
    _cancelSleepTimer();
    audioPlayer.dispose();
  }
}
