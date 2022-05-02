import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_search_provider.dart';

class MainSearchRepository {
  final MainSearchApiClient apiClient;

  MainSearchRepository({@required this.apiClient}) : assert(apiClient != null);
}
