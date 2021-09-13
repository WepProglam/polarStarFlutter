import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main_provider.dart';
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
}
