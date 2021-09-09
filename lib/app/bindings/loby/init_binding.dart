import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';

import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';

import 'package:get/get.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(InitController(
        repository: LoginRepository(apiClient: LoginApiClient())));
  }
}
