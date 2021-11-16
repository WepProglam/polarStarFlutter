// ignore_for_file: slash_for_doc_comments

/**
 * 앞으로 여기다가 validator 작성
 * https://pub.dev/documentation/validators/latest/validators/validators-library.html
 * 여기 문서 참고
 */

String checkEmpty(String value) {
  if (value.isEmpty) {
    return "Please fill the blank";
  } else {
    return null;
  }
}
