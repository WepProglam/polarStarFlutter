int getIndexFromDay(String day) {
  int index = 0;
  switch (day) {
    case "월":
      index = 0;
      break;
    case "화":
      index = 1;
      break;
    case "수":
      index = 2;
      break;
    case "목":
      index = 3;
      break;
    case "금":
      index = 4;
      break;
    case "토":
      index = 5;
      break;
    case "일":
      index = 6;
      break;
    default:
      index = 0;
      break;
  }
  return index;
}
