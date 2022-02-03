String timetableSemChanger(int year, int semester) {
  String sem = "";
  switch (semester) {
    case 1:
      sem = "1";
      break;
    case 2:
      sem = "1";
      break;
    case 3:
      sem = "2";
      break;
    case 4:
      sem = "2";
      break;
    default:
  }
  return "${year}学年度 第${sem}学期";
}

String dayConverter(String day) {
  if (day == "월" || day == "월요일") {
    return "周一";
  } else if (day == "화" || day == "화요일") {
    return "周二";
  } else if (day == "수" || day == "수요일") {
    return "周三";
  } else if (day == "목" || day == "목요일") {
    return "周四";
  } else if (day == "금" || day == "금요일") {
    return "周五";
  } else if (day == "토" || day == "토요일") {
    return "周六";
  } else if (day == "일" || day == "일요일") {
    return "周日";
  }
}

int flutterToServerSemChanger(int semester) {
  int sem = 1;
  switch (semester) {
    case 1:
      sem = 1;
      break;
    case 2:
      sem = 3;
      break;
    default:
  }
  return sem;
}
