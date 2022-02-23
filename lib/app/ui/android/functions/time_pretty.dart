import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

String prettyDate(DateTime date) {
  if (date == null) {
    return null;
  }
  DateTime now = DateTime.now();
  if (date.year != now.year) {
    return "${date.year}-${date.month}-${date.day}";
  } else if (date.month != now.month || date.day != now.day) {
    return "${addZero(date.month)}月 ${addZero(date.day)}日";
  } else {
    // return timeFormatter(date);
    return "${addZero(date.hour)}时 ${addZero(date.minute)}分";
  }
}

String prettyChatDate(DateTime date) {
  if (date == null) {
    return null;
  }
  // if (date.hour < 12) {
  //   return "AM ${addZero(date.hour)}:${addZero(date.minute)}";
  // } else {
  //   return "PM ${addZero(date.hour)}:${addZero(date.minute)}";
  // }
  return "${addZero(date.hour)}:${addZero(date.minute)}";
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
    if (item.day == null) {
      return "미지정";
    }
    a +=
        "${item.day} ${addZero(item.start_time.hour)}:${addZero(item.start_time.minute)}~${addZero(item.end_time.hour)}:${addZero(item.end_time.minute)} ";
  }
  return a.trim();
}
