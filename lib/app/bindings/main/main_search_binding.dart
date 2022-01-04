import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_search_controller.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_search_provider.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_search_repository.dart';

class MainSearchBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(MainSearchController(
    //     repository: MainSearchRepository(apiClient: MainSearchApiClient())));
    Get.lazyPut<MainSearchController>(() => MainSearchController(
        repository: MainSearchRepository(apiClient: MainSearchApiClient())));
  }
}
