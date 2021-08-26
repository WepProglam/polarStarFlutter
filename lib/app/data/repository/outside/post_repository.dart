import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/outside/post_provider.dart';

class OutSidePostRepository {
  final OutSidePostApiClient apiClient;

  OutSidePostRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getPostData(
      int COMMUNITY_ID, int BOARD_ID) async {
    final Map<String, dynamic> response =
        await apiClient.getPostData(COMMUNITY_ID, BOARD_ID);

    return {
      "statusCode": response["statusCode"],
      "listPost": response["listPost"]
    };
  }
}
