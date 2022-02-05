import 'dart:math';

String convertFileName(String url) {
  String aws = "/";
  String file_name = url.split(aws).last;
  int file_extend_length = file_name.split(".").last.length + 1;
  int length_limit = 10;
  if (file_extend_length > length_limit) {
    return file_name.substring(0, 2) + "..." + file_name.split(".").last;
  }
  int space = length_limit - file_extend_length;

  // if (file_name.length > length_limit) {
  int last_start = file_name.length - space ~/ 2 - file_extend_length;
  String first_string = file_name.substring(0, space ~/ 2);
  String middle_string = "...";
  String last_string = file_name.substring(last_start);
  return first_string + middle_string + last_string;
  // }

  return file_name;
}

String trimFileName(String filename) {
  if (filename == null) {
    return "unknown file";
  } else if (filename.length >= 20) {
    return filename.substring(0, 20) + "...";
  } else {
    return filename;
  }
}

String trimExpire(String expire) {
  if (expire == null) {
    return "unknown date";
  } else {
    DateTime expire_date = DateTime.parse(expire);
    return "${expire_date}".split(" ")[0];
  }
}

String trimFileSize(int bytes) {
  if (bytes == null) {
    return "unknown size";
  }
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
}
