import 'package:music_player/providers/services/theme_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/model/app_theme.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider(AppTheme.lightMode);
});
