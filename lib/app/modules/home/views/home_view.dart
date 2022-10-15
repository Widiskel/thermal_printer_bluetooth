import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:thermal_printer/app/resources/color_pallete.dart';
import 'package:thermal_printer/app/resources/thermal.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  @override
  final controller = Get.put(
    HomeController(),
  );
  // final thermal = Get.find<Thermal>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Thermal Printer",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                border: Border.all(
                  color: appBlack,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30)),
            child: GetBuilder<Thermal>(builder: (controller) {
              controller.update();
              return Column(
                children: [
                  DropdownButton(
                    isExpanded: true,
                    items: controller.getDeviceItems(),
                    onChanged: (BluetoothDevice? value) {
                      controller.device = value;
                      controller.update();
                    },
                    value: controller.device,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: appBlue),
                        onPressed: () {
                          controller.initPlatformState();
                        },
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: controller.connected.value
                                ? appPink
                                : appGreen),
                        onPressed: () {
                          controller.connected.value
                              ? controller.disconnect()
                              : controller.connect();
                        },
                        child: Text(
                          controller.connected.value ? 'Disconnect' : 'Connect',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: appBlue),
                    onPressed: () {
                      controller.printsomething();
                    },
                    child: const Text(
                      'Print',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      )),
    );
  }
}
