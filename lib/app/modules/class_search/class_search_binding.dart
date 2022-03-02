import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/class_search/class_search_controller.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class ClassSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ClassSearchController(
        repository: ClassRepository(apiClient: ClassApiClient())));
  }
}
