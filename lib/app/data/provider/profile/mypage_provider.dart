import 'dart:convert';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:http/http.dart' as http;

class MyPageApiClient {
  Future<Map<String, dynamic>> getMineWrite() async {
    var response = await Session().getX("/info");
    var responseBody = jsonDecode(response.body);
    var profileData = responseBody["PROFILE"];
    Iterable listMyPageBoard = responseBody["WritePost"];
    List<Rx<Post>> listMyPageBoardVal;
    MyProfileModel myProfile;

    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
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
    List<Rx<Post>> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["LIKE"];
    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> getMineScrap() async {
    var response = await Session().getX("/info/scrap");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "myPageBoard": []};
    }

    var responseBody = jsonDecode(response.body);
    List<Rx<Post>> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["SCRAP"];
    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> uploadProfileImage(
      http.MultipartFile photo) async {
    var request = Session().multipartReq('PATCH', '/info/modify/photo');

    request.files.add(photo);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return {
      "status": response.statusCode,
      "src": jsonDecode(response.body)["src"]
    };
  }
}
