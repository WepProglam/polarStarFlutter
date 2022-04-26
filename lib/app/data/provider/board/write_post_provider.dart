import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:polarstar_flutter/session.dart';

class WritePostApiClient {
  Future<Map> postPostNoImage(Map<String, dynamic> data, String url) async {
    print(data);

    var response = await Session().postX(url, data);
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return {"statusCode": response.statusCode, "jsonResponse": jsonResponse};
  }

  Future<int> putPostNoImage(Map<String, dynamic> data, String url) async {
    var response = await Session().putX(url, data);
    return response.statusCode;
  }

  Future<Map> postPostImage(Map<String, dynamic> data,
      List<http.MultipartFile> pic, int COMMUNITY_ID) async {
    http.MultipartRequest request =
        Session().multipartReq('POST', '/board/$COMMUNITY_ID');

    request.files.addAll(pic);
    request.fields['title'] = data['title'];
    request.fields['description'] = data['description'];
    request.fields['unnamed'] = data['unnamed'];

    print(request.files);

    var response = await request.send();
    final jsonResponse = jsonDecode(await utf8.decodeStream(response.stream));

    print(jsonResponse);
    return {"statusCode": response.statusCode, "jsonResponse": jsonResponse};
  }

  Future<int> putPostImage(Map<String, dynamic> data,
      List<http.MultipartFile> pic, int COMMUNITY_ID, int BOARD_ID) async {
    var request =
        Session().multipartReq('PUT', '/board/$COMMUNITY_ID/bid/$BOARD_ID');

    request.files.addAll(pic);
    request.fields['title'] = data['title'];
    request.fields['description'] = data['description'];
    request.fields['unnamed'] = data['unnamed'];
    var response = await request.send();
    return response.statusCode;
  }
}
