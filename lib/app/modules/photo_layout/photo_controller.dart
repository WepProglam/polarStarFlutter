import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';
import 'package:http/http.dart' as http;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoController extends GetxController {
  RxInt photo_index = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    photo_index.value = 0;
  }

  //페이지 나갈 때 게시판 리스트 업데이트
  @override
  void onClose() async {
    super.onClose();
  }
}
