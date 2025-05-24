import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/services/audio_service.dart';

class PermissionService {
  final BuildContext context;
  final AudioService audioService;

  PermissionService(this.context, this.audioService);

  Future<void> requestPermission() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (context.mounted) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        if (await Permission.audio.isGranted ||
            await Permission.storage.isGranted) {
          await audioService.fetchSongs();
        } else {
          if (deviceInfo.version.sdkInt > 32) {
            await Permission.audio.request();
          } else {
            await Permission.storage.request();
          }
          if (await Permission.audio.isGranted ||
              await Permission.storage.isGranted) {
            await audioService.fetchSongs();
          }
        }
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await Permission.mediaLibrary.isGranted) {
          await audioService.fetchSongs();
        } else {
          await Permission.mediaLibrary.request();
          if (await Permission.mediaLibrary.isGranted) {
            await audioService.fetchSongs();
          }
        }
      }
    }
  }
}
