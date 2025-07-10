// import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShuffleOrderLoopController extends GetxController {
  final RxBool _isOrder = true.obs;
  final RxBool _isShuffle = false.obs;
  final RxBool _isLoop = false.obs;
  bool get isOrder => _isOrder.value;
  bool get isShuffle => _isShuffle.value;
  bool get isLoop => _isLoop.value;

  void updateOptions() {
    if (isOrder) {
      _isOrder.value = false;
      _isShuffle.value = true;
      _isLoop.value = false;
      // print('Switched to Shuffle: $isShuffle');
    } else if (isShuffle) {
      _isOrder.value = false;
      _isShuffle.value = false;
      _isLoop.value = true;
      // print('Switched to Loop: $isLoop');
    } else {
      _isOrder.value = true;
      _isShuffle.value = false;
      _isLoop.value = false;
      // print('Switched to Order: $isOrder');
    }
  }
}
