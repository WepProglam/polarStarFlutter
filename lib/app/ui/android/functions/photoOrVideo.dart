final video_extension = [
  "webm",
  "mkv",
  "vob",
  "ogv",
  "ogg",
  "drc",
  "mng",
  "avi",
  "MTS",
  "M2TS",
  "TS",
  "mov",
  "qt",
  "wmv",
  "yuv",
  "rm",
  "rmvb",
  "viv",
  "asf",
  "amv",
  "mp4",
  "m4p",
  "mp2",
  "mpe",
  "mpv",
  "mpg",
  "mpeg",
  "m2v",
  "m4v",
  "svi",
  "3gp",
  "3g2",
  "mxf",
  "roq",
  "nsv",
  "flv",
  "f4v",
  "f4p",
  "f4a",
  "f4b"
];
final photo_extension = [
  "apng",
  "avif",
  "gif",
  "jpg",
  "jpeg",
  "jfif",
  "pjpeg",
  "pjp",
  "png",
  "svg",
  "webp",
  "octet-stream"
];

bool isPhoto(String url) {
  // * 임시방편
  if (!isVideo(url)) {
    return true;
  }
  String extension = url.split(".").last;
  if (photo_extension.indexOf(extension.toLowerCase()) != -1) {
    return true;
  }
  return false;
}

bool isVideo(String url) {
  String extension = url.split(".").last;
  if (video_extension.indexOf(extension) != -1) {
    return true;
  }
  return false;
}
