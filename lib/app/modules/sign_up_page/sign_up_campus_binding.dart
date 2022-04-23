import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_controller.dart';
import 'package:polarstar_flutter/app/data/repository/sign_up_repository.dart';
import 'package:polarstar_flutter/app/data/provider/sign_up_provider.dart';

class SignUpCampusBinding implements Bindings {
  @override
  void dependencies() async {
    SignUpController controller = Get.put(SignUpController(
        repository: SignUpRepository(apiClient: SignUpApiClient())));

    await controller.getCampusInfo();
  }
}
