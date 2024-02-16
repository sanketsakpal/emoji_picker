import 'package:emoji_picker/helper/shared_preference_helper.dart';
import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:flutter/material.dart';

class EmojisList extends StatefulWidget {
  const EmojisList({
    Key? key,
    required this.cross,
    required this.textController,
    required this.tabController,
    required this.emojiDataModel,
    required this.recentEmojis,
  }) : super(key: key);

  final int cross;
  final TextEditingController textController;
  final TabController tabController;
  final EmojiDataModel emojiDataModel;
  final List<String> recentEmojis;

  @override
  State<EmojisList> createState() => _EmojisListState();
}

class _EmojisListState extends State<EmojisList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: widget.tabController,
        children: List.generate(
          widget.emojiDataModel.categories?.length ?? 0,
          (index) => GridView.builder(
            itemCount: widget.emojiDataModel.categories?[index].emojis?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cross,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2),
            itemBuilder: (context, emojiIndex) => GestureDetector(
              onTap: () async {
                widget.textController
                  ..text += widget.emojiDataModel.categories?[index]
                          .emojis?[emojiIndex].emoji ??
                      ""
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.textController.text.length),
                  );
                await SharedPreferenceHelper.setRecentEmojiMap(
                    widget
                        .emojiDataModel.categories?[index].emojis?[emojiIndex],
                    widget.emojiDataModel);
                await SharedPreferenceHelper.getRecentEmojiMaps();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    widget.emojiDataModel.categories?[index].emojis?[emojiIndex]
                            .emoji ??
                        "test",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
