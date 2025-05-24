import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongOptionsModal extends ConsumerWidget {
  final SongModel song;
  final AudioService audioService;

  const SongOptionsModal({
    super.key,
    required this.song,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Song Header
          Row(
            children: [
              QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkWidth: 60,
                artworkHeight: 60,
                artworkBorder: BorderRadius.circular(8),
                keepOldArtwork: true,
                nullArtworkWidget: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary.withAlpha(210),
                  ),
                  child: const Icon(Icons.music_note, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              // Song Title
              Expanded(
                child: Text(
                  song.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOption(
                    context,
                    icon: Icons.delete,
                    label: 'Delete',
                    onTap: () {},
                  ),
                  _buildOption(
                    context,
                    icon: Icons.edit,
                    label: 'Rename',
                    onTap: () {},
                  ),
                  _buildOption(
                    context,
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {},
                  ),
                  _buildOption(
                    context,
                    icon: Icons.playlist_add,
                    label: 'Add to Playlist',
                    onTap: () {},
                  ),
                  _buildOption(
                    context,
                    icon: Icons.ring_volume,
                    label: 'Set as Ringtone',
                    onTap: () {},
                  ),
                  _buildOption(
                    context,
                    icon: Icons.remove_red_eye,
                    label: 'View Details',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
