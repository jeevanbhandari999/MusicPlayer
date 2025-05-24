import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  final WidgetRef ref;

  AudioService(this.ref) {
    // Listen to currentIndexStream for song changes
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index != ref.read(currentSongIndexProvider)) {
        ref.read(currentSongIndexProvider.notifier).state = index;
        ref.read(isPlayingProvider.notifier).state = audioPlayer.playing;
      }
    });

    // Additional debugging for playback state
    audioPlayer.playingStream.listen((playing) {
      print('Playing state changed: $playing');
    });

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        ref.read(isPlayingProvider.notifier).state = false;
      }
    });
  }

  Future<void> fetchSongs() async {
    List<SongModel> songs = await onAudioQuery.querySongs();

    // Filter out songs with invalid URIs
    songs =
        songs
            .where((song) => song.uri != null && song.uri!.isNotEmpty)
            .toList();
    if (songs.isEmpty) {
      return;
    }

    ref.read(songsProvider.notifier).state = songs;
    try {
      // final playlist = ConcatenatingAudioSource(
      //   children:
      //       songs.map((song) {
      //         return AudioSource.uri(Uri.parse(song.uri!));
      //       }).toList(),
      // );
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
    print(
      'playSong called with index: $index, currentIndex: $currentIndex, isPlaying: $isPlaying',
    );

    if (songs.isEmpty) {
      return;
    }

    // If the same song is tapped and currently playing, pause it
    if (currentIndex == index && isPlaying) {
      print('Pausing song at index: $index');
      await audioPlayer.pause();
      ref.read(isPlayingProvider.notifier).state = false;
    } else {
      // If a different song is selected or the same song is not playing, play it
      if (currentIndex != index) {
        print('Setting new audio source for index: $index');
        try {
          await audioPlayer.setAudioSources(
            songs.map((song) {
              return AudioSource.uri(Uri.parse(song.uri!));
            }).toList(),
            initialIndex: index,
            initialPosition: Duration.zero,
          );
          // await audioPlayer.setAudioSource(
          //   ConcatenatingAudioSource(
          //     children:
          //         songs
          //             .map((song) => AudioSource.uri(Uri.parse(song.uri!)))
          //             .toList(),
          //   ),
          //   initialIndex: index,
          //   initialPosition: Duration.zero,
          // );
          ref.read(currentSongIndexProvider.notifier).state = index;
        } catch (e) {
          return;
        }
      }
      print('Playing song at index: $index');
      await audioPlayer.play();
      ref.read(isPlayingProvider.notifier).state = true;
    }
  }

  Future<void> playNext() async {
    final songs = ref.read(songsProvider);
    final currentIndex = ref.read(currentSongIndexProvider);
    print(
      'playNext called, currentIndex: $currentIndex, total songs: ${songs.length}',
    );

    if (currentIndex != null && currentIndex < songs.length - 1) {
      await audioPlayer.seekToNext();
      final newIndex = currentIndex + 1;
      ref.read(currentSongIndexProvider.notifier).state = newIndex;
      await audioPlayer.play();
      ref.read(isPlayingProvider.notifier).state = true;
      print('Current index changed to: $newIndex');
    }
  }

  Future<void> playPrevious() async {
    final currentIndex = ref.read(currentSongIndexProvider);
    print('playPrevious called, currentIndex: $currentIndex');

    if (currentIndex != null && currentIndex > 0) {
      await audioPlayer.seekToPrevious();
      final newIndex = currentIndex - 1;
      ref.read(currentSongIndexProvider.notifier).state = newIndex;
      await audioPlayer.play();
      ref.read(isPlayingProvider.notifier).state = true;
    }
  }

  Future<void> deleteSong(int songId) async {
    // Check for write permission
    if (!await Permission.storage.request().isGranted) {
      throw Exception('Storage permission denied');
    }

    // Delete the song
    // final success = await onAudioQuery.removeFromPlaylist(songId);
    // if (!success) {
    //   throw Exception('Failed to delete song');
    // }

    // Refresh the song list
    await fetchSongs();

    // If the deleted song was playing, stop playback
    final currentIndex = ref.read(currentSongIndexProvider);
    if (currentIndex != null &&
        ref.read(songsProvider)[currentIndex].id == songId) {
      await audioPlayer.stop();
      ref.read(currentSongIndexProvider.notifier).state = null;
      ref.read(isPlayingProvider.notifier).state = false;
    }
  }

  Future<void> updateSongTitle(int songId, String newTitle) async {
    // Check for write permission
    if (!await Permission.storage.request().isGranted) {
      throw Exception('Storage permission denied');
    }

    // Update song metadata (simplified, as on_audio_query doesn't directly support this)
    // In a real app, use a platform channel or external library for metadata editing

    // Refresh the song list to reflect changes
    await fetchSongs();
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
