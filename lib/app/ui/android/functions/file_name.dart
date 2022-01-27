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
