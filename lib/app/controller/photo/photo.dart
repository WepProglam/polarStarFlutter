import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';
import 'package:http/http.dart' as http;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoController extends GetxController {
  final AssetEntity photo;

  PhotoController({
    @required this.photo,
  });

  @override
  void onInit() async {
    super.onInit();
  }

  //페이지 나갈 때 게시판 리스트 업데이트
  @override
  void onClose() async {
    super.onClose();
  }
}
