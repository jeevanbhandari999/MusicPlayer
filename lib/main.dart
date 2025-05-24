import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/screens/music_player_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
      home: const MusicPlayerScreen(),
    );
  }
}
