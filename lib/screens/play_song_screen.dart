import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:music_player/widgets/playback_controls.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PlaySongScreen extends ConsumerWidget {
  const PlaySongScreen({super.key, required this.audioService});
  final AudioService audioService;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final currentSongIndex = ref.watch(currentSongIndexProvider);
    if (currentSongIndex == null || songs.isEmpty) {
      return const SizedBox.shrink();
    }
    final song = songs[currentSongIndex];

    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                            trackWidth: 4,
                            progressBarWidth: 6,
                            handlerSize: 8,
                          ),
                          customColors: CustomSliderColors(
                            trackColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(150),
                            progressBarColors: [
                              Colors.green,
                              Colors.greenAccent,
                            ],
                            dotColor: Colors.white,
                          ),
                          size: 400,
                          angleRange: 360,
                          startAngle: 270,
                        ),
                        min: 0,
                        max:
                            duration.inSeconds.toDouble() > 0
                                ? duration.inSeconds.toDouble()
                                : 1.0,
                        initialValue: position.inSeconds.toDouble(),
                        onChange: (double value) async {
                          await audioService.audioPlayer.seek(
                            Duration(seconds: value.toInt()),
                          );
                        },
                        innerWidget:
                            (_) => Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: QueryArtworkWidget(
                                  id: currentSongIndex,
                                  type: ArtworkType.AUDIO,
                                  artworkWidth: 360,
                                  artworkHeight: 360,
                                  artworkFit: BoxFit.cover,
                                  keepOldArtwork: true,
                                  nullArtworkWidget: Container(
                                    width: 360,
                                    height: 360,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withAlpha(60),
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
                  );
                },
              );
            },
          ),
          PlaybackControls(audioService: audioService),
        ],
      ),
    );
  }
}
