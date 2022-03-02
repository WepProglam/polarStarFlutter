import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';

class MainRepository {
  final MainApiClient apiClient;

  MainRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getBoardInfo(
      List<String> follwingCommunity) async {
    return await apiClient.getBoardInfo(follwingCommunity);
  }

  Future<Map<String, dynamic>> getNewBoard(int page) async {
    final json = await apiClient.getNewBoard(page);
    return json;
  }

  Future<Map<String, String>> versionCheck() async {
    final json = await apiClient.versionCheck();
    return json;
  }

  Future<Map<String, dynamic>> createCommunity(
      String COMMUNITY_NAME, String COMMUNITY_DESCRIPTION) async {
    var status =
        await apiClient.createCommunity(COMMUNITY_NAME, COMMUNITY_DESCRIPTION);
    return status;
  }

  Future<List<LikeListModel>> refreshLikeList() async {
    var response = await apiClient.refreshLikeList();
    return response.map((e) => LikeListModel.fromJson(e)).toList();
  }

  Future<List<ScrapListModel>> refreshScrapList() async {
    var response = await apiClient.refreshScrapList();
    return response.map((e) => ScrapListModel.fromJson(e)).toList();
  }
}
