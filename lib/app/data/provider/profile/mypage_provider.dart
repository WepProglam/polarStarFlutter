import 'dart:convert';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:http/http.dart' as http;

class MyPageApiClient {
  Future<Map<String, dynamic>> getMineWrite() async {
    var response = await Session().getX("/info");
    var responseBody = jsonDecode(response.body);
    var profileData = responseBody["PROFILE"];
    Iterable listMyPageBoard = responseBody["WritePost"];
    List<MyPageBoardModel> listMyPageBoardVal;
    MyProfileModel myProfile;

    listMyPageBoardVal = listMyPageBoard
        .map((model) => MyPageBoardModel.fromJson(model))
        .toList();
    myProfile = MyProfileModel.fromJson(profileData);

    return {
      "status": response.statusCode,
      "myPageBoard": listMyPageBoardVal,
      "myProfile": myProfile
    };
  }

  Future<Map<String, dynamic>> getMineLike() async {
    var response = await Session().getX("/info/like");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "myPageBoard": []};
    }

    var responseBody = jsonDecode(response.body);
    List<MyPageBoardModel> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["LIKE"];
    listMyPageBoardVal = listMyPageBoard
        .map((model) => MyPageBoardModel.fromJson(model))
        .toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> getMineScrap() async {
    var response = await Session().getX("/info/scrap");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "myPageBoard": []};
    }

    var responseBody = jsonDecode(response.body);
    List<MyPageBoardModel> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["SCRAP"];
    listMyPageBoardVal = listMyPageBoard
        .map((model) => MyPageBoardModel.fromJson(model))
        .toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> uploadProfileImage(String imagePath) async {
    var request = Session().multipartReq('PATCH', '/info/modify/photo');

    var pic = await http.MultipartFile.fromPath("photo", imagePath);
    request.files.add(pic);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return {
      "status": response.statusCode,
      "src": jsonDecode(response.body)["src"]
    };
  }
}
