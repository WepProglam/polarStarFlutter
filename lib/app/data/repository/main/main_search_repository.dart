import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_search_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class MainSearchRepository {
  final MainSearchApiClient apiClient;

  MainSearchRepository({@required this.apiClient}) : assert(apiClient != null);
}
