import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:flutter/material.dart';

class EmojiTabBar extends StatelessWidget {
  const EmojiTabBar({
    Key? key,
    required this.tabController,
    required this.emojiDataModel,
  }) : super(key: key);
  final TabController tabController;
  final EmojiDataModel emojiDataModel;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.blue[700],
      labelStyle: const TextStyle(fontSize: 25),
      unselectedLabelStyle: const TextStyle(fontSize: 20),
      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      indicator: BoxDecoration(
          color: Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(10)),
      tabs: List.generate(
        emojiDataModel.categories!.length,
        (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 35,
            child: Tab(
              text: emojiDataModel.categories?[index].categoryNameEmoji ?? "",
            ),
          ),
        ),
      ),
    );
  }
}
