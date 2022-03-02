import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/modules/class/class_controller.dart';
import 'package:polarstar_flutter/app/modules/claa_view/widgets/write_comment_controller.dart';

class ClassBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ClassController(
        repository: ClassRepository(apiClient: ClassApiClient())));
  }
}
