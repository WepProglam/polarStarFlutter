import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

bool checkFollow(int COMMUNITY_ID, List<Rx<BoardInfo>> followCommunity) {
  bool flag = false;
  followCommunity.forEach((element) {
    if (element.value.COMMUNITY_ID == COMMUNITY_ID) {
      flag = true;
      return;
    }
  });

  print("${COMMUNITY_ID} $flag");
  return flag;
}
