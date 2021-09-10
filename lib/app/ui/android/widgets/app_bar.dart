import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/session.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String pageName;

  CustomAppBar({@required this.pageName});

  @override
  Size get preferredSize => Size.fromHeight(50);
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$pageName'),
      actions: [
        IconButton(
            onPressed: () {
              Get.toNamed('/class');
            },
            icon: Text("Class")),
        IconButton(
            onPressed: () async {
              Session().getX('/logout');
              Session.cookies = {};
              Session.headers['Cookie'] = '';

              box.write('isAutoLogin', false);
              box.remove('id');
              box.remove('pw');
              box.remove('token');

              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
              Get.offAllNamed('/');
            },
            icon: Text('LOGOUT')),
        IconButton(
            onPressed: () {
              Get.toNamed('/myPage');
            },
            icon: Icon(Icons.person)),
      ],
    );
  }
}

class WritePostAppBar extends StatelessWidget with PreferredSizeWidget {
  final int COMMUNITY_ID;

  WritePostAppBar({this.COMMUNITY_ID});

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    print(COMMUNITY_ID);
    return AppBar(
      title: Text('${communityBoardName(COMMUNITY_ID)}'),
      actions: [
        Container(
          width: 40,
          child: InkWell(
              onTap: () {
                Get.toNamed('/board/$COMMUNITY_ID');
              },
              child: Icon(
                Icons.add,
              )),
        )
      ],
    );
  }
}
