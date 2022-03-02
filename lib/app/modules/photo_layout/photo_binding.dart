import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/photo_layout/photo_controller.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_bin_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_bin_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';

class TimetableBinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoController>((() => PhotoController()));
  }
}
