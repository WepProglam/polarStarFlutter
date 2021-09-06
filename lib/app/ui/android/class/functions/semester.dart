String semester(int intSemester) {
  String retString = "First";
  switch (intSemester) {
    case 1:
      retString = "First";
      break;
    case 2:
      retString = "Second";
      break;
    default:
      retString = "First";
  }
  return retString;
}
