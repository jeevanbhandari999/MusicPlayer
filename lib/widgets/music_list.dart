import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:music_player/widgets/more_options_about_music.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/services/audio_service.dart';

class MusicListWidget extends ConsumerWidget {
  final AudioService audioService;

  const MusicListWidget({super.key, required this.audioService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final currentSongIndex = ref.watch(currentSongIndexProvider);
    final isPlaying = ref.watch(isPlayingProvider);

    return Expanded(
      child:
          songs.isEmpty
              ? const Center(child: Text('No songs found'))
              : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      leading: QueryArtworkWidget(
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
                          child: const Icon(Icons.music_note, size: 28),
                        ),
                      ),
                      title: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              currentSongIndex == index && isPlaying
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
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
                      trailing: IconButton(
                        key: ValueKey<bool>(
                          currentSongIndex == index && isPlaying,
                        ),
                        icon: Icon(Icons.more_vert, size: 28),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder:
                                (context) => SongOptionsModal(
                                  song: song,
                                  audioService: audioService,
                                ),
                          );
                        },
                        splashRadius: 20,
                        tooltip:
                            currentSongIndex == index && isPlaying
                                ? 'Pause'
                                : 'Play',
                      ),
                      onTap: () => audioService.playSong(index),
                    ),
                  );
                },
              ),
    );
  }
}
