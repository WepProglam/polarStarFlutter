import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';

class ClassViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ClassViewController(
        repository: ClassRepository(apiClient: ClassApiClient())));
  }
}
