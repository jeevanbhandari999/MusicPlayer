import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/permission_service.dart';
import 'package:music_player/widgets/floating_music.dart';
import 'package:music_player/widgets/music_list.dart';
import 'package:music_player/widgets/sidebar_drawer.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  MusicPlayerScreenState createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {
  late final AudioService audioService;
  late final PermissionService permissionService;

  @override
  void initState() {
    super.initState();
    audioService = AudioService(ref);
    permissionService = PermissionService(context, audioService);
    permissionService.requestPermission();
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: IconButton(
          //     onPressed: () {
          //       theme.toggleTheme();
          //     },
          //     icon: Icon(Icons.search, size: 30),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                theme.toggleTheme();
              },
              icon: Icon(
                theme.isDarkMode ? Icons.sunny : Icons.nights_stay,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      drawer: SidebarDrawer(),
      body: Stack(
        children: [
          Column(children: [MusicListWidget(audioService: audioService)]),
          isPlaying
              ? FloatingMusicWidget(audioService: audioService)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
