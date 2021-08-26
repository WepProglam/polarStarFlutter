import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';

class MyPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPageController>(() => MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));
  }
}
