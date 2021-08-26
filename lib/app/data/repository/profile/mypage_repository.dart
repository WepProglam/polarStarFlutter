import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';

class MyPageRepository {
  final MyPageApiClient apiClient;

  MyPageRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getMineWrite() async {
    return await apiClient.getMineWrite();
  }

  Future<Map<String, dynamic>> getMineLike() async {
    return await apiClient.getMineLike();
  }

  Future<Map<String, dynamic>> getMineScrap() async {
    return await apiClient.getMineScrap();
  }

  Future<Map<String, dynamic>> uploadProfileImage(String imagePath) async {
    var map = await apiClient.uploadProfileImage(imagePath);
    return map;
  }
}
