import 'package:polarstar_flutter/session.dart';

class WritePostApiClient {
  Future<int> postPostNoImage(Map<String, dynamic> data, String url) async {
    var response = await Session().postX(url, data);
    return response.statusCode;
  }

  Future<int> putPostNoImage(Map<String, dynamic> data, String url) async {
    var response = await Session().putX(url, data);
    return response.statusCode;
  }

  Future<int> postPostImage(
      Map<String, dynamic> data, pic, int COMMUNITY_ID) async {
    var request = Session().multipartReq('POST', '/board/$COMMUNITY_ID');

    request.files.add(pic);
    request.fields['title'] = data['title'];
    request.fields['description'] = data['description'];
    request.fields['unnamed'] = data['unnamed'];
    var response = await request.send();
    return response.statusCode;
  }

  Future<int> putPostImage(
      Map<String, dynamic> data, pic, int COMMUNITY_ID, int BOARD_ID) async {
    var request =
        Session().multipartReq('PUT', '/board/$COMMUNITY_ID/bid/$BOARD_ID');

    request.files.add(pic);
    request.fields['title'] = data['title'];
    request.fields['description'] = data['description'];
    request.fields['unnamed'] = data['unnamed'];
    var response = await request.send();
    return response.statusCode;
  }
}
