import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_mail_dialog.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/post_menu_item.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/photo/photo_layout.dart';
import 'package:polarstar_flutter/main.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    Key key,
    @required this.item,
    @required this.mainController,
    @required this.c,
    @required this.index,
  }) : super(key: key);

  final Rx<Post> item;
  final MainController mainController;
  final PostController c;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 게시글 좋아요 수 버튼
        TextButton.icon(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () async {
            if (item.value.MYSELF) {
              Get.snackbar("게시글 좋아요", "내가 쓴 게시글에는 할 수 없습니다.",
                  snackPosition: SnackPosition.BOTTOM);
            } else if (mainController.isLiked(item.value)) {
            } else {
              int status_code = await c.totalSend(
                  '/like/${item.value.COMMUNITY_ID}/id/${item.value.UNIQUE_ID}',
                  '좋아요',
                  index);
            }
          },
          icon: Container(
            width: PostIconSize,
            height: PostIconSize,
            child: (mainController.isLiked(item.value)
                ? AssetImageBin.likeClickedIcon
                : AssetImageBin.likeNoneIcon),
          ),
          label: Text(item.value.LIKES.toString(),
              style: const TextStyle(
                  color: const Color(0xff6f6e6e),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        // 게시글 댓글 수 버튼
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
          onPressed: null,
          icon: Container(
            width: PostIconSize,
            height: PostIconSize,
            child: AssetImageBin.commentIcon,
          ),
          label: Text("${c.sortedList.length - 1}",
              style: const TextStyle(
                  color: const Color(0xff6f6e6e),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        // 게시글 스크랩 수 버튼
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
          onPressed: () async {
            if (mainController.isScrapped(item.value)) {
              int status_code = await c.scrap_cancel(
                  '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}');
            } else {
              int status_code = await c.totalSend(
                  '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}',
                  '스크랩',
                  index);
            }
          },
          icon: Container(
            width: PostIconSize,
            height: PostIconSize,
            child: mainController.isScrapped(item.value)
                ? AssetImageBin.scrapClickedIcon
                : AssetImageBin.scrapNoneIcon,
          ),
          label: Text(item.value.SCRAPS.toString(),
              style: const TextStyle(
                  color: const Color(0xff6f6e6e),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }
}

class PostBody extends StatelessWidget {
  const PostBody({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Rx<Post> item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Container(
          child: Text("${item.value.TITLE}",
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w700,
                  fontFamily: "NotoSansTC",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        // 내용
        Container(
          child: Text("${item.value.CONTENT}",
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansTC",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        //사진
        (item.value.PHOTO != [] &&
                item.value.PHOTO != null &&
                item.value.PHOTO.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
                child: PhotoLayout(model: item.value),
              )
            : Container(),
      ],
    );
  }
}

class PostTop extends StatelessWidget {
  const PostTop({
    Key key,
    @required this.item,
    @required this.c,
    @required this.index,
    @required this.mailWriteController,
    @required this.mailController,
  }) : super(key: key);

  final Rx<Post> item;
  final PostController c;
  final int index;
  final TextEditingController mailWriteController;
  final MailController mailController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 프로필 사진
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 10),
          child: CachedNetworkImage(
            imageUrl: '${item.value.PROFILE_PHOTO}',
            imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover))),
          ),
        ),
        //닉네임, 작성 시간
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.value.PROFILE_NICKNAME,
                  style: const TextStyle(
                      color: const Color(0xff2f2f2f),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left),
              Text(
                  item.value.TIME_CREATED
                      .substring(2, 19)
                      .replaceAll('-', '.')
                      .replaceAll('T', ' '),
                  style: const TextStyle(
                      color: const Color(0xff6f6e6e),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.left),
            ],
          ),
        ),
        Spacer(),
        PopupMenuButton(
            child: Container(
              width: 24,
              height: 24,
              child: Image.asset("assets/images/icn_more.png"),
            ),
            onSelected: (value) async {
              if (value == "게시글 수정") {
                await updatePostFunc(item);
              } else if (value == "게시글 삭제") {
                await deletePostFunc(item, c);
              } else if (value == "게시글 신고") {
                await arrestPostFunc(c, item, index);
              } else if (value == "쪽지 보내기") {
                await sendMailPostFunc(
                    c, item, mailWriteController, mailController);
              }
            },
            itemBuilder: (context) {
              if (item.value.MYSELF) {
                return [
                  PopupMenuItem(
                    child: Text("게시글 수정"),
                    value: "게시글 수정",
                  ),
                  PopupMenuItem(
                    child: Text("게시글 삭제"),
                    value: "게시글 삭제",
                  ),
                ];
              } else {
                return [
                  PopupMenuItem(
                    child: Text("게시글 신고"),
                    value: "게시글 신고",
                  ),
                  PopupMenuItem(
                    child: Text("쪽지 보내기"),
                    value: "쪽지 보내기",
                  ),
                ];
              }
            }),
      ],
    );
  }
}
