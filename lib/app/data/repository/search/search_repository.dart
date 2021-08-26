import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/search/search_provider.dart';

class SearchRepository {
  final SearchApiClient apiClient;

  SearchRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getSearchBoard(
      String searchText, int COMMUNITY_ID, String from) async {
    final json = await apiClient.getSearchBoard(searchText, COMMUNITY_ID, from);
    return json;
  }
}
