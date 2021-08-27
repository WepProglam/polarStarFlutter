import 'package:polarstar_flutter/session.dart';

class SignUpApiClient {
  Future<Map> signUpApi(data) async {
    var response = await Session().postX('/signup', data);
    return {"statusCode": response.statusCode};
  }
}
