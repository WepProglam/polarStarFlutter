import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getClassMain() async {
    final response = await Session().getX('/class');
    return response;
  }

  Future getClassSearch(String searchText) async {
    final response = await Session().getX('/class/search?search=$searchText');
    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      return {"statusCode": 200};
    }
  }
}
