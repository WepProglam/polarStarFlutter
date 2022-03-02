import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/modules/add_class/timetable_addclass_controller.dart';

class TimetableClassBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TimeTableAddClassController(
        repository: TimeTableAddClassRepository(
            apiClient: TimeTableAddClassApiClient())));
    // Get.lazyPut<TimeTableAddClassController>((() => TimeTableAddClassController(
    //     repository: TimeTableAddClassRepository(
    //         apiClient: TimeTableAddClassApiClient()))));
  }
}
