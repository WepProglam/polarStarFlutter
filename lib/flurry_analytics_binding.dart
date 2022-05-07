import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_controller.dart';
import 'package:polarstar_flutter/app/data/repository/sign_up_repository.dart';
import 'package:polarstar_flutter/app/data/provider/sign_up_provider.dart';
import 'package:polarstar_flutter/flurry_analytics.dart';

class FlurryBinding implements Bindings {
  @override
  void dependencies() {
    print(Get.currentRoute);
    logFlurryEvent(Get.currentRoute);
  }
}
