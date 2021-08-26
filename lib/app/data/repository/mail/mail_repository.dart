import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

class MailRepository {
  final MailApiClient apiClient;

  MailRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> sendMailOut(
      int UNIQUE_ID, int COMMUNITY_ID, String content) async {
    return await apiClient.sendMailOut(UNIQUE_ID, COMMUNITY_ID, content);
  }

  Future<Map<String, dynamic>> sendMailIn(
      int MAIL_BOX_ID, String content) async {
    return await apiClient.sendMailIn(MAIL_BOX_ID, content);
  }

  Future<Map<String, dynamic>> getMail(int MAIL_BOX_ID) async {
    //쪽지 내역 보기
    return await apiClient.getMail(MAIL_BOX_ID);
  }

  Future<Map<String, dynamic>> getMailBox() async {
    //쪽지함 보기
    return await apiClient.getMailBox();
  }
}
