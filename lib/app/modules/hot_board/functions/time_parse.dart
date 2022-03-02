String timeParsing(String createdTime, String updatedTime) {
  String originalTime = createdTime;

  if (updatedTime != null) {
    originalTime = updatedTime;
  }

  String parsedTime = originalTime
      .replaceAll("-", ".")
      .replaceFirst("T", " ")
      .substring(0, originalTime.length - 5);

  return parsedTime;
}

String timeFormatter(DateTime time) {
  String returnString = "${time.hour}:";

  if (time.hour.toString().length < 2) {
    returnString = "0" + returnString;
  }

  if (time.minute.toString().length < 2) {
    returnString += "0${time.minute}";
  } else {
    returnString += "${time.minute}";
  }

  return returnString;
}
