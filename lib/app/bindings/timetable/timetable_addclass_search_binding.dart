import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page.dart';

class TimetableClassSearchBinding implements Bindings {
  @override
  void dependencies() {
    putController<TimeTableController>();
    Get.lazyPut<TimeTableAddClassSearchController>((() =>
        TimeTableAddClassSearchController(
            repository: TimeTableAddClassRepository(
                apiClient: TimeTableAddClassApiClient()))));
  }
}
