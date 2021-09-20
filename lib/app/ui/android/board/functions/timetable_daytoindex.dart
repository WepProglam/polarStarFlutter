int getIndexFromDay(String day) {
  int index = 0;
  switch (day) {
    case "월요일":
      index = 0;
      break;
    case "화요일":
      index = 1;
      break;
    case "수요일":
      index = 2;
      break;
    case "목요일":
      index = 3;
      break;
    case "금요일":
      index = 4;
      break;
    case "토요일":
      index = 5;
      break;
    case "일요일":
      index = 6;
      break;
    default:
      index = 0;
      break;
  }
  return index;
}
