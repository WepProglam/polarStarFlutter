String timetableSemChanger(int year, int semester) {
  String sem = "";
  switch (semester) {
    case 1:
      sem = "1";
      break;
    case 2:
      sem = "여름";
      break;
    case 3:
      sem = "2";
      break;
    case 4:
      sem = "겨울";
      break;
    default:
  }
  return "${year}年 第${sem}学期";
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
