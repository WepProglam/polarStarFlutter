import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

String prettyDate(DateTime date) {
  DateTime now = DateTime.now();
  if (date.year != now.year) {
    return "${date.year}-${date.month}-${date.day}";
  } else if (date.month != now.month || date.day != now.day) {
    return "${addZero(date.month)}월 ${addZero(date.day)}일";
  } else {
    // return timeFormatter(date);
    return "${addZero(date.hour)}시 ${addZero(date.minute)}분";
  }
}

String addZero(int time) {
  String returnTime = "${time}";
  if (returnTime.length == 1) {
    return "0" + returnTime;
  }
  return returnTime;
}

String classTimePretty(List<AddClassModel> source) {
  String a = "";
  for (var item in source) {
    a +=
        "${item.day} ${addZero(item.start_time.hour)}:${addZero(item.start_time.minute)}~${addZero(item.end_time.hour)}:${addZero(item.end_time.minute)} ";
  }
  return a.trim();
}
