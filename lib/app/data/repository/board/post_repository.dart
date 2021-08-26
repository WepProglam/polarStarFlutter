import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/board/post_provider.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class PostRepository {
  final PostApiClient apiClient;

  PostRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getPostData(
      int COMMUNITY_ID, int BOARD_ID) async {
    final Map<String, dynamic> response =
        await apiClient.getPostData(COMMUNITY_ID, BOARD_ID);

    return {
      "statusCode": response["statusCode"],
      "listPost": response["listPost"]
    };
  }

  Future<int> deleteResource(
      int COMMUNITY_ID, int UNIQUE_ID, String tag) async {
    final status = await apiClient.deleteResource(COMMUNITY_ID, UNIQUE_ID, tag);
    return status;
  }

  Future<int> postComment(String url, var data) async {
    final status = await apiClient.postComment(url, data);
    return status;
  }

  Future<int> putComment(String url, var data) async {
    final status = await apiClient.putComment(url, data);
    return status;
  }
}
