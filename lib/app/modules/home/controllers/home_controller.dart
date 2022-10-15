// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';

import '../../../resources/thermal.dart';

class HomeController extends GetxController {
  // ignore: todo
  //TODO: Implement HomeController

  final thermal = Get.put(
    Thermal(),
    permanent: true,
  );

  @override
  void onInit() {
    super.onInit();
    thermal.initPlatformState();
    thermal.getDeviceItems();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
