import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/sign_up_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class SignUpRepository {
  final SignUpApiClient apiClient;

  SignUpRepository({@required this.apiClient}) : assert(apiClient != null);

  signUp(data) async {
    data["pw"] = crypto_sign_up(data["id"], data["pw"]);

    final response = await apiClient.signUpApi(data);
    return response;
  }

  IDTest(data) async {
    final response = await apiClient.IDTestApi(data);
    return response;
  }

  emailAuthRequest(data) async {
    final response = await apiClient.emailAuthRequestApi(data);
    return response;
  }

  emailAuthVerify(data) async {
    final response = await apiClient.emailAuthVerifyApi(data);
    return response;
  }
}
