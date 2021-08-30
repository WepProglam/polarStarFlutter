import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassSearchBar extends StatelessWidget {
  const ClassSearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchText = TextEditingController();

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
              hintText: 'search class',
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
                  onTap: () {
                    Get.toNamed("/class/search?search=${searchText.text}");
                  },
                  child: Icon(
                    Icons.search_outlined,
                    color: Colors.grey,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
