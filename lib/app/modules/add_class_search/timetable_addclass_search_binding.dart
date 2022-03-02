import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/modules/add_class_search/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';

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
