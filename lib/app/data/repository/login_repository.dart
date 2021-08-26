import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class LoginRepository {
  final LoginApiClient apiClient;

  LoginRepository({@required this.apiClient}) : assert(apiClient != null);

  login(data) async {
    await apiClient.getSalt();
    data['pw'] = crypto_login(data["id"], data["pw"]);
    final response = await apiClient.getLogin(data);
    return response;
  }
}
