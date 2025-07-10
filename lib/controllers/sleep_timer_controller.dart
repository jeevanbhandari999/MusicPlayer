import 'package:get/get.dart';

class SleepTimerController extends GetxController {
  final RxBool _isSetTimer = false.obs;
  bool get isSetTimer => _isSetTimer.value;

  
}
