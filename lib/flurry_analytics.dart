import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/init_page/pushy_controller.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:flurry/flurry.dart';

String _FLURRY_API_KEY_AND = "2Q59HKPFVVYB8X5DWG9Z";
String _FLURRY_API_KEY_IOS = "GC2ZGNKNZS7HT3CNFB9V";

Future<void> initFlurryPlatformState(String userId) async {
  await Flurry.initialize(
      androidKey: _FLURRY_API_KEY_AND,
      iosKey: _FLURRY_API_KEY_IOS,
      enableLog: true);
  await Flurry.setUserId(userId);
}

Future<void> logFlurryEvent(String eventName) async {
  await Flurry.logEvent(eventName);
}
