import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';

// 게시글 프리뷰 위젯
class PostPreview extends StatelessWidget {
  const PostPreview({Key key, @required this.item}) : super(key: key);
  final Board item;

  String boardName(int COMMUNITY_ID) {
    return communityBoardName(COMMUNITY_ID);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(item);
        Get.toNamed('/board/${item.COMMUNITY_ID}/read/${item.BOARD_ID}');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Container(
          // height: 200,
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(width: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 프로필 이미지 & 닉네임
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Container(
                            // 그냥 사이즈 표기용
                            // decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 30,
                            child: CachedNetworkImage(
                                imageUrl:
                                    'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}',
                                fit: BoxFit.fill,
                                fadeInDuration: Duration(milliseconds: 0),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Image(
                                        image: AssetImage('image/spinner.gif')),
                                errorWidget: (context, url, error) {
                                  print(error);
                                  return Icon(Icons.error);
                                }),
                          ),
                        ),
                        Text(item.PROFILE_NICKNAME),
                      ],
                    ),
                  ),
                  // 제목, 내용
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제목
                          Text(
                            item.TITLE,
                            textScaleFactor: 1.5,
                            maxLines: 1,
                          ),
                          // 내용
                          Text(
                            item.CONTENT,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  // Photo
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // 그냥 사이즈 표기용
                      // decoration: BoxDecoration(border: Border.all()),
                      height: 50,
                      width: 50,
                      child: item.PHOTO == '' || item.PHOTO == null
                          ? Container()
                          : CachedNetworkImage(
                              imageUrl:
                                  'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/board/${item.PHOTO}',
                              fit: BoxFit.fill,
                              fadeInDuration: Duration(milliseconds: 0),
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  Image(image: AssetImage('image/spinner.gif')),
                              errorWidget: (context, url, error) {
                                print(error);
                                return Icon(Icons.error);
                              }),
                    ),
                  ),
                ],
              ),
              // 게시판, 좋아요, 댓글, 스크랩
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Text(boardName(item.COMMUNITY_ID) + '게시판'),
                    Spacer(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.thumb_up,
                            size: 15,
                          ),
                        ),
                        Text(item.LIKES.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.comment,
                            size: 15,
                          ),
                        ),
                        Text(item.COMMENTS.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.bookmark,
                            size: 15,
                          ),
                        ),
                        Text(item.SCRAPS.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
