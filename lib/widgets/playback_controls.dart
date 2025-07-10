import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/shuffle_order_loop_controller.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/widgets/music_list.dart';

class PlaybackControls extends ConsumerWidget {
  final AudioService audioService;

  PlaybackControls({super.key, required this.audioService});
  final ShuffleOrderLoopController optionsController =
      Get.find<ShuffleOrderLoopController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongIndex = ref.watch(currentSongIndexProvider);
    final isPlaying = ref.watch(isPlayingProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.primary.withAlpha(50),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: IconButton(
              icon: Obx(
                () => Icon(
                  optionsController.isOrder
                      ? Icons.format_list_numbered
                      : optionsController.isShuffle
                      ? Icons.shuffle
                      : Icons.repeat_one,
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                optionsController.updateOptions();
              },
              iconSize: 36,
              padding: const EdgeInsets.all(12),
              splashRadius: 24,
              tooltip: 'Shuffle',
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.primary.withAlpha(50),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.green),
              onPressed: audioService.playPrevious,
              iconSize: 36,
              padding: const EdgeInsets.all(12),
              splashRadius: 24,
              tooltip: 'Previous',
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(200),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withAlpha(90),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  key: ValueKey<bool>(isPlaying),
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (currentSongIndex != null) {
                  audioService.playSong(currentSongIndex);
                }
              },
              iconSize: 40,
              padding: const EdgeInsets.all(16),
              splashRadius: 28,
              tooltip: isPlaying ? 'Pause' : 'Play',
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.primary.withAlpha(50),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.green),
              onPressed: () {
                audioService.playNext();
                // audioService.playNext();
              },
              iconSize: 36,
              padding: const EdgeInsets.all(12),
              splashRadius: 24,
              tooltip: 'Next',
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.primary.withAlpha(50),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: IconButton(
              icon: const Icon(Icons.queue_music, color: Colors.green),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(),
                  builder: (ctx) => MusicListWidget(audioService: audioService),
                );
              },
              iconSize: 36,
              padding: const EdgeInsets.all(12),
              splashRadius: 24,
              tooltip: 'Musics',
            ),
          ),
        ],
      ),
    );
  }
}
