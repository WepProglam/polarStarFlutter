import 'package:polarstar_flutter/session.dart';

class LoginApiClient {
  getSalt() async {
    var response = await Session().getX('/login');
    Session.salt = await Session().updateCookie(response, 'salt');
  }

  Future<Map> getLogin(data) async {
    var response = await Session().postX('/login', data);
    Session.session = Session().updateCookie(response, 'connect.sid');
    return {"statusCode": response.statusCode};
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