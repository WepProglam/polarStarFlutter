import 'package:meta/meta.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';

class TimeTableAddClassRepository {
  final TimeTableAddClassApiClient apiClient;

  TimeTableAddClassRepository({@required this.apiClient})
      : assert(apiClient != null);
}
