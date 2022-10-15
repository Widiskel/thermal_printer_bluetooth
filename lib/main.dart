import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:fullscreen/fullscreen.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
