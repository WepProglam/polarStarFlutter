import 'package:polarstar_flutter/session.dart';

class SignUpApiClient {
  Future<Map> signUpApi(data) async {
    var response = await Session().postX('/signup', data);
    return {"statusCode": response.statusCode};
  }

  Future<Map> emailAuthRequestApi(data) async {
    var response = await Session().postX('/signup/emailAuthRequest', data);
    print(data);

    return {"statusCode": response.statusCode};
  }

  Future<Map> IDTestApi(data) async {
    var response = await Session().postX('/signup/IDTest', data);
    print(data);

    return {"statusCode": response.statusCode};
  }

  Future<Map> emailAuthVerifyApi(data) async {
    var response = await Session().postX('/signup/emailAuthVerify', data);
    print(data);
    return {"statusCode": response.statusCode};
  }
}
