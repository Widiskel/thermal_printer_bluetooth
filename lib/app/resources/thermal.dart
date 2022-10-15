// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Thermal extends GetxController {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> ldevices = [];
  BluetoothDevice? device;
  RxBool connected = false.obs;

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          show("bluetooth device state: connected");
          connected = true.obs;
          update();
          break;
        case BlueThermalPrinter.DISCONNECTED:
          show("bluetooth device state: disconnected");
          connected = false.obs;
          update();
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          show("bluetooth device state: disconnect requested");
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          print("bluetooth device state: bluetooth turning off");
          break;
        case BlueThermalPrinter.STATE_OFF:
          show("bluetooth device state: bluetooth off");
          break;
        case BlueThermalPrinter.STATE_ON:
          show("bluetooth device state: bluetooth on ready to connect");
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          show("bluetooth device state: bluetooth turning on");
          break;
        case BlueThermalPrinter.ERROR:
          show("bluetooth device state: error");
          break;
        default:
          print(state);

          break;
      }
    });

    // if (!mounted) return;

    ldevices = devices;

    // if (isConnected == true) {
    //   // disconnect();
    //   connected = false.obs;
    // } else {
    //   // connect();
    //   connected = true.obs;
    // }
    print('ref iscon : $isConnected , con : $connected ');
    update();
  }

  List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (ldevices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE , Please refresh'),
      ));
      show('No Device Detected!!');
    } else {
      for (var device in ldevices) {
        items.add(DropdownMenuItem(
          // ignore: sort_child_properties_last
          child: Text(device.name ?? ""),
          value: device,
        ));
      }
    }
    return items;
  }

  void connect() async {
    if (device != null) {
      // bluetooth.connect(device!);
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected == false) {
        bluetooth.connect(device!).catchError((error) {
          show(error);
        });
        show('Connectd to : ${device?.name}');
        connected = true.obs;
      } else {
        show('Connectd to : ${device?.name}');
        connected = true.obs;
      }
    } else {
      show('No device selected.');
    }
    update();
  }

  void disconnect() {
    bluetooth.disconnect();
    connected = false.obs;
    show('Disconnected from ${device?.name}');
    update();
  }

  void printsomething() async {
    ByteData bytesAsset = await rootBundle.load("assets/image/yourlogo.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    bluetooth.printCustom("Thermal Print", 4, 1, charset: "windows-1250");
    bluetooth.printImageBytes(imageBytesFromAsset);
    bluetooth.printCustom(
        "Thermal printer test laksjdkla jsdkljaslkdj dklsadjkldasjk", 0, 0,
        charset: "windows-1250");
    bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
    bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 0);
    bluetooth.printQRcode("waputra16@gmail.com", 200, 200, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.paperCut();
    update();
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Get.snackbar("Message :", message);
  }
}
