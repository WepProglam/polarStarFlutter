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
