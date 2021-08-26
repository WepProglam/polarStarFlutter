import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/board/post_provider.dart';
import 'package:polarstar_flutter/app/data/provider/board/write_post_provider.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class WritePostRepository {
  final WritePostApiClient apiClient;

  WritePostRepository({@required this.apiClient}) : assert(apiClient != null);

  //게시글 새로 작성 (사진 X)
  Future<int> postPostNoImage(Map<String, dynamic> data, String url) async {
    return await apiClient.postPostNoImage(data, url);
  }

  //게시글 수정 (사진 X)
  Future<int> putPostNoImage(Map<String, dynamic> data, String url) async {
    return await apiClient.putPostNoImage(data, url);
  }

  //게시글 작성 (사진 O)
  Future<int> postPostImage(
      Map<String, dynamic> data, pic, int COMMUNITY_ID) async {
    int status = await apiClient.postPostImage(data, pic, COMMUNITY_ID);
    return status;
  }

  //게시글 수정 (사진 O)
  Future<int> putPostImage(
      Map<String, dynamic> data, pic, int COMMUNITY_ID, int BOARD_ID) async {
    int status =
        await apiClient.putPostImage(data, pic, COMMUNITY_ID, BOARD_ID);
    return status;
  }
}
