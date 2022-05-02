import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';

class MyPageRepository {
  final MyPageApiClient apiClient;

  MyPageRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getMineProfile() async {
    return await apiClient.getMineProfile();
  }

  Future<Map<String, dynamic>> getMineWrite(int page) async {
    return await apiClient.getMineWrite(page);
  }

  Future<Map<String, dynamic>> getMineLike(int page) async {
    return await apiClient.getMineLike(page);
  }

  Future<Map<String, dynamic>> getMineScrap(int page) async {
    return await apiClient.getMineScrap(page);
  }

  Future<Map<String, dynamic>> uploadProfileImage(MultipartFile photo) async {
    var map = await apiClient.uploadProfileImage(photo);
    return map;
  }
}
