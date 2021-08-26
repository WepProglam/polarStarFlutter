import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/outside/outside_provider.dart';

class OutSideRepository {
  final OutSideApiClient apiClient;

  OutSideRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getBoard(int COMMUNITY_ID, int page) async {
    final json = await apiClient.getBoard(COMMUNITY_ID, page);
    return json;
  }

  Future<Map<String, dynamic>> getSearchBoard(
      String searchText, int COMMUNITY_ID) async {
    final json = await apiClient.getSearchBoard(searchText, COMMUNITY_ID);
    return json;
  }

  Future<Map<String, dynamic>> getSearchAll(String searchText) async {
    final json = await apiClient.getSearchAll(searchText);
    return json;
  }
}
