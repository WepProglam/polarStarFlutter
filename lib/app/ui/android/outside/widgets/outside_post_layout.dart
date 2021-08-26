// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/controller/outside/post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';

class OutSidePostLayout extends StatelessWidget {
  OutSidePostLayout({this.c});

  final OutSidePostController c;

  // MailController mailController = Get.find();
  final mailWriteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> finalPost = returningPost(c.postContent.value);

    return Container(
      height: MediaQuery.of(context).size.height - 60 - 100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: finalPost,
        ),
      ),
    );
  }

  List<Widget> returningPost(Post item) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration:
              BoxDecoration(border: BorderDirectional(top: BorderSide())),
          child: Row(
            children: [
              // 프로필 사진
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: CachedNetworkImage(
                      imageUrl:
                          'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}'),
                ),
              ),
              //닉네임, 작성 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.PROFILE_NICKNAME),
                  Text(
                    item.TIME_CREATED
                        .substring(2, 16)
                        .replaceAll(RegExp(r'-'), '/'),
                    textScaleFactor: 0.6,
                  ),
                ],
              ),
              Spacer(),
              // 게시글 좋아요 버튼
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    c.totalSend(
                        '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                        '좋아요');
                  },
                  child: Icon(Icons.thumb_up),
                ),
              ),
              // 게시글 수정, 스크랩 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    c.totalSend(
                        '/scrap/${item.COMMUNITY_ID}/id/${item.BOARD_ID}',
                        '스크랩');
                  },
                  child: Icon(Icons.bookmark),
                ),
              ),
            ],
          ),
        ),
      ),
      // 제목
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: Text(
            "${item.TITLE}",
            textScaleFactor: 2,
          ),
        ),
      ),
      // 내용
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: Text(
            "${item.CONTENT}",
            textScaleFactor: 1.5,
          ),
        ),
      ),
      //사진
      Container(
        child: item.PHOTO != '' && item.PHOTO != null
            ? CachedNetworkImage(
                imageUrl:
                    'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/outside/${item.PHOTO}')
            : null,
      ),
      // 좋아요, 스크랩 수
      Container(
        decoration:
            BoxDecoration(border: BorderDirectional(bottom: BorderSide())),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              // 게시글 좋아요 수 버튼
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  if (item.MYSELF) {
                  } else {
                    c.totalSend(
                        '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                        '좋아요');
                  }
                },
                icon: Icon(
                  Icons.thumb_up,
                  size: 20,
                ),
                label: Text("${item.LIKES}"),
              ),

              // 게시글 스크랩 수 버튼
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow[700])),
                onPressed: () {
                  c.totalSend(
                      '/scrap/${item.COMMUNITY_ID}/id/${item.BOARD_ID}', '스크랩');
                },
                icon: Icon(
                  Icons.bookmark,
                  size: 20,
                ),
                label: Text("${item.SCRAPS}"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ];
  }
}
