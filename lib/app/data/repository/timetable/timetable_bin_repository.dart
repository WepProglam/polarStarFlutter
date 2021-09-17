import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_bin_provider.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';

class TimeTableBinRepository {
  final TimetableBinClient apiClient;

  TimeTableBinRepository({@required this.apiClient})
      : assert(apiClient != null);
}
