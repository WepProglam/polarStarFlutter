import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_bin_controller.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_bin_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_bin_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';

class TimetableBinBinding implements Bindings {
  @override
  void dependencies() {
    // TimeTableBinController timeTableController = TimeTableBinController(
    //     repository: TimeTableBinRepository(apiClient: TimetableBinClient()));
    // Get.put(timeTableController);

    Get.lazyPut<TimeTableBinController>((() => TimeTableBinController(
        repository: TimeTableBinRepository(apiClient: TimetableBinClient()))));
  }
}
