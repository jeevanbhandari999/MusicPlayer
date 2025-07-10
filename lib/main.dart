import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/controllers/image_picker_controller.dart';
import 'package:music_player/controllers/shuffle_order_loop_controller.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/routes/routes_info.dart';
import 'package:get/get.dart';
// import 'package:music_player/services/audio_service.dart';

void main() {
  Get.put(ShuffleOrderLoopController());
  Get.put(ImagePickerController());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return GetMaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
      initialRoute: '/',
      getPages: RoutesInfo.routes,
    );
  }
}
