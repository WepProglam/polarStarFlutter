final video_extension = ["mp4"];
final photo_extension = ["jpg, png"];

bool isPhoto(String url) {
  String extension = url.split(".").last;
  if (photo_extension.indexOf(extension) != -1) {
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
