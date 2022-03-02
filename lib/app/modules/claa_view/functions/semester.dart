String semester(int intSemester) {
  String retString = "First";
  switch (intSemester) {
    case 1:
      retString = "First";
      break;
    case 3:
      retString = "Second";
      break;
    default:
      retString = "First";
  }
  return retString;
}

String examType(int examIndex) {
  String retExam = "중간";
  switch (examIndex) {
    case 0:
      retExam = "중간";
      break;
    case 1:
      retExam = "기말";
      break;
    default:
      retExam = "중간";
  }
  return retExam;
}
