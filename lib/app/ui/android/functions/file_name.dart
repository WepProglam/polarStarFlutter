import 'dart:math';

String convertFileName(String url) {
  String aws = "/";
  String file_name = url.split(aws).last;
  int file_extend_length = file_name.split(".").last.length + 1;
  int length_limit = 5 + 5 + file_extend_length;
  if (file_name.length > length_limit) {
    int last_start = file_name.length - 5 - file_extend_length;
    String first_string = file_name.substring(0, 5);
    String middle_string = "...";
    print(file_name);
    String last_string = file_name.substring(last_start);
    return first_string + middle_string + last_string;
  }

  return file_name;
}

String preventOverflow(String filename) {
  if (filename == null) {
    return "unknown file";
  } else if (filename.length >= 25) {
    return filename.substring(0, 25) + "...";
  } else {
    return filename;
  }
}

String getFileSize(int bytes) {
  if (bytes == null) {
    return "unknown size";
  }
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
}
