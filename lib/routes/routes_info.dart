import 'package:get/get.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/screens/settings.dart';
import 'package:music_player/screens/sleep_timer.dart';
// import 'package:music_player/screens/play_song_screen.dart';
// import 'package:music_player/services/audio_service.dart';

// late final AudioService audioService;

class RoutesInfo {
  static const String initial = '/';
  static const String sleepTimer = '/SleepTimer';
  static const String playSong = '/PlaySongScreen';
  static const String settings = '/Settings';

  static String getInitialPage() => initial;
  static String getSleepTimerPage() => sleepTimer;
  static String getSettingsPage() => settings;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => MusicPlayerScreen()),
    GetPage(name: sleepTimer, page: () => SleepTimer()),
    GetPage(name: settings, page: () => SettingsPage()),
  ];
}
