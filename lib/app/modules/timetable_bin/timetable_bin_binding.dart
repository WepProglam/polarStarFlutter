import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/timetable_bin/timetable_bin_controller.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_bin_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_bin_repository.dart';

class TimetableListBinding implements Bindings {
  @override
  void dependencies() {
    // TimeTableBinController timeTableController = TimeTableBinController(
    //     repository: TimeTableBinRepository(apiClient: TimetableBinClient()));
    // Get.put(timeTableController);

    Get.lazyPut<TimeTableBinController>((() => TimeTableBinController(
        repository: TimeTableBinRepository(apiClient: TimetableBinClient()))));
  }
}
