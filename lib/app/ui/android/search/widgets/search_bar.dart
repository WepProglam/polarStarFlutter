// 검색창
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key, @required this.controller}) : super(key: key);
  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = TextEditingController(
        text: controller.searchText.value == null
            ? ""
            : controller.searchText.value);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          TextFormField(
            controller: searchText,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              hintText: 'search',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            ),
            style: TextStyle(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                    child: InkWell(
                  onTap: () async {
                    await controller.getSearchBoard(searchText.text);
                    searchText.clear();
                    Get.toNamed("/searchBoard");
                  },
                  child: Icon(Icons.search_outlined),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
