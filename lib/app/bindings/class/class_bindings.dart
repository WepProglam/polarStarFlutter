import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

class ClassBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassController>(() => ClassController(
        repository: ClassRepository(apiClient: ClassApiClient())));
  }
}
