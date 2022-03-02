import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';

class TimetableBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeTableController>((() => TimeTableController(
        repository: TimeTableRepository(apiClient: TimetableApiClient()))));
  }
}
