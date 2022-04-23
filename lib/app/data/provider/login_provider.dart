import 'dart:convert';

import 'package:polarstar_flutter/session.dart';

class LoginApiClient {
  getSalt() async {
    var response = await Session().getX('/login');
    Session.salt = await Session().updateCookie(response, 'salt');
  }

  Future<Map> postLogin(data) async {
    print("post login");
    print(data);
    var response = await Session().postX('/login', data);
    Session.session = Session().updateCookie(response, 'connect.sid');
    print("update session");
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return {
      "statusCode": response.statusCode,
      "CAMPUS_ID": jsonResponse["CAMPUS_ID"]
    };
  }

  Future<int> tokenRefresh(data) async {
    var response = await Session().postX("/login/fcmToken", data);
    return response.statusCode;
  }

  Future<Map<String, String>> versionCheck() async {
    final response = await Session().getX('/versionCheck');
    final jsonResponse = jsonDecode(response.body);

    return {
      "status": response.statusCode.toString(),
      "min_version": jsonResponse["min_version"],
      "latest_version": jsonResponse["latest_version"]
    };
  }
}


// getAll() async {
//     try {
//       var response = await Session().get(baseUrl);
//       if (response.statusCode == 200) {
//         Iterable jsonResponse = json.decode(response.body);
//         List<MyModel> listMyModel =
//             jsonResponse.map((model) => MyModel.fromJson(model)).toList();
//         return listMyModel;
//       } else
//         print('erro');
//     } catch (_) {}
//   }

//   getId(id) async {
//     try {
//       var response = await Session().get(baseUrl);
//       if (response.statusCode == 200) {
//         //Map<String, dynamic> jsonResponse = json.decode(response.body);
//       } else
//         print('erro -get');
//     } catch (_) {}
//   }