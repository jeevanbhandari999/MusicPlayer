import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/providers/music_player_provider.dart';
// import 'package:music_player/services/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  // final AudioService _audioService = Get.find<AudioService>();
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final RxBool _isLoading = false.obs;

  File? get pickedImage => _pickedImage.value;
  bool get isLoading => _isLoading.value;

  Future<void> pickImage() async {
    _isLoading.value = true;

    // Request Photos permission for Android 13+ and media access for older versions
    PermissionStatus status;
    if (Platform.isAndroid) {
      if (await DeviceInfoPlugin().androidInfo.then(
        (info) => info.version.sdkInt >= 33,
      )) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      // For iOS, use photos permission
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            '${directory.path}/custom_artwork_${DateTime.now().millisecondsSinceEpoch}.png';
        final savedImage = await File(image.path).copy(imagePath);
        _pickedImage.value = savedImage;
      }
    } else if (status.isDenied) {
      Get.snackbar(
        'Permission Denied',
        'Please allow photo access in settings to pick images.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          child: const Text('Open Settings'),
          onPressed: () => openAppSettings(),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Permanently Denied',
        'Please enable photo access in app settings.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          child: const Text('Open Settings'),
          onPressed: () => openAppSettings(),
        ),
      );
    }
    _isLoading.value = false;
  }

  Future<void> saveArtworkForSong(int songId) async {
    if (_pickedImage.value == null) {
      Get.snackbar(
        'No Image',
        'Please pick an image first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;
    try {
      final songs = Get.find<ProviderContainer>().read(songsProvider);
      final songIndex = songs.indexWhere((song) => song.id == songId);
      if (songIndex != -1) {
        // Save the image path to a custom map or database (e.g., local storage)
        final customArtworks = await loadCustomArtworks();
        customArtworks[songId] = _pickedImage.value!.path;
        await _saveCustomArtworks(customArtworks);

        // Update UI or notify listeners (e.g., refresh song list)
        Get.find<ProviderContainer>()
            .read(songsProvider.notifier)
            .state = List.from(songs);
        Get.snackbar(
          'Success',
          'Artwork saved for the song.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Song not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save artwork: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      // print(e);
    }
    _isLoading.value = false;
  }

  Future<Map<int, String>> loadCustomArtworks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/custom_artworks.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      return (contents.isNotEmpty)
          ? Map<int, String>.from(jsonDecode(contents) as Map)
          : <int, String>{};
    }
    return <int, String>{};
  }

  Future<void> _saveCustomArtworks(Map<int, String> artworks) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/custom_artworks.json');
    await file.writeAsString(jsonEncode(artworks));
  }

  void clearPickedImage() {
    _pickedImage.value = null;
  }
}
