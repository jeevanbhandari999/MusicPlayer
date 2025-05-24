import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:music_player/screens/play_song_screen.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FloatingMusicWidget extends ConsumerWidget {
  final AudioService audioService;

  const FloatingMusicWidget({super.key, required this.audioService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final currentSongIndex = ref.watch(currentSongIndexProvider);
    final isPlaying = ref.watch(isPlayingProvider);

    if (currentSongIndex == null || songs.isEmpty) {
      return const SizedBox.shrink();
    }

    final song = songs[currentSongIndex];

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlaySongScreen(audioService: audioService),
            ),
          );
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),

          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.green),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withAlpha(70),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Artwork
                    QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 50,
                      artworkHeight: 50,
                      artworkBorder: BorderRadius.circular(8),
                      keepOldArtwork: true,
                      nullArtworkWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(60),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Song Title and Artist
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            song.artist ?? 'Unknown Artist',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: audioService.playPrevious,
                          iconSize: 24,
                          padding: const EdgeInsets.all(8),
                          splashRadius: 20,
                          tooltip: 'Previous',
                        ),
                        IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder:
                                (child, animation) => ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              key: ValueKey<bool>(isPlaying),
                            ),
                          ),
                          onPressed:
                              () => audioService.playSong(currentSongIndex),
                          iconSize: 28,
                          padding: const EdgeInsets.all(8),
                          splashRadius: 20,
                          tooltip: isPlaying ? 'Pause' : 'Play',
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: audioService.playNext,
                          iconSize: 24,
                          padding: const EdgeInsets.all(8),
                          splashRadius: 20,
                          tooltip: 'Next',
                        ),
                      ],
                    ),
                  ],
                ),
                StreamBuilder<Duration>(
                  stream: audioService.audioPlayer.positionStream,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: audioService.audioPlayer.durationStream,
                      builder: (context, durationSnapshot) {
                        final duration = durationSnapshot.data ?? Duration.zero;
                        return Column(
                          children: [
                            Slider(
                              value: position.inSeconds.toDouble(),
                              max:
                                  duration.inSeconds.toDouble() > 0
                                      ? duration.inSeconds.toDouble()
                                      : 1.0,
                              onChanged: (value) async {
                                await audioService.audioPlayer.seek(
                                  Duration(seconds: value.toInt()),
                                );
                              },
                              activeColor: Colors.green,
                              inactiveColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(150),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
