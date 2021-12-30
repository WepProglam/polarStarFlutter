import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class MainRepository {
  final MainApiClient apiClient;

  MainRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getBoardInfo(
      List<String> follwingCommunity) async {
    return await apiClient.getBoardInfo(follwingCommunity);
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
