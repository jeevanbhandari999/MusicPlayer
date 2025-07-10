import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/services/audio_service.dart';

class SleepTimer extends ConsumerStatefulWidget {
  const SleepTimer({super.key});

  @override
  ConsumerState<SleepTimer> createState() => _SleepTimerState();
}

class _SleepTimerState extends ConsumerState<SleepTimer> {
  late final AudioService audioService;

  @override
  void initState() {
    super.initState();
    audioService = AudioService(ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            print('Button pressed, audioService: $audioService');
            if (audioService != null) {
              audioService.startSleepTimer(20);
            } else {
              print('AudioService is null');
            }
          },
          child: Text('Set'),
        ),
      ),
    );
  }
}
