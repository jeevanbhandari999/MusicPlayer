import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

final songsProvider = StateProvider<List<SongModel>>((ref) => []);
final currentSongIndexProvider = StateProvider<int?>((ref) => null);
final isPlayingProvider = StateProvider<bool>((ref) => false);