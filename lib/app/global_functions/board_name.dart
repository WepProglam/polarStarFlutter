import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

final box = GetStorage();

String communityBoardName(int COMMUNITY_ID) {
  List<BoardInfo> boardList = box.read('boardInfo');
  for (BoardInfo item in boardList) {
    if (item.COMMUNITY_ID == COMMUNITY_ID) {
      return item.COMMUNITY_NAME;
    }
  }
  return null;
}
