// ignore_for_file: slash_for_doc_comments

/**
 * 앞으로 여기다가 validator 작성
 * https://pub.dev/documentation/validators/latest/validators/validators-library.html
 * 여기 문서 참고
 */

String checkEmpty(String value) {
  if (value.isEmpty) {
    return "빈칸입니다 ㅅl ㅂr 정신차리세요";
  } else {
    return null;
  }
}
