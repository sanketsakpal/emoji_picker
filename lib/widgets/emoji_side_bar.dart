import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EmojiSideBar extends StatefulWidget {
  EmojiSideBar(
      {super.key,
      required this.controller,
      required this.tabController,
      required this.selectedTab,
      required this.emojiDataModel});
  ScrollController? controller;
  EmojiDataModel emojiDataModel;
  TabController tabController;
  int selectedTab;
  @override
  State<EmojiSideBar> createState() => _EmojiSideBarState();
}

class _EmojiSideBarState extends State<EmojiSideBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: ListView.builder(
        controller: widget.controller,
        itemCount: widget.emojiDataModel.categories!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.selectedTab = index;
              widget.tabController.animateTo(index);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: widget.selectedTab == index
                      ? Colors.grey.shade300
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                widget.emojiDataModel.categories![index].categoryNameEmoji
                    .toString(),
                style: const TextStyle(fontSize: 25),
              ),
            ),
          );
        },
      ),
    );
  }
}
