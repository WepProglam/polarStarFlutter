import 'package:polarstar_flutter/app/controller/login/login_controller.dart';

import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';

import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController(
        repository: LoginRepository(apiClient: LoginApiClient())));
  }
}
