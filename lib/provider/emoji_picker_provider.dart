import 'package:emoji_picker/helper/shared_preference_helper.dart';
import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:emoji_picker/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmojiDataPickerProvider extends ChangeNotifier {
  EmojiDataModel _emojiDataModel = EmojiDataModel();
  EmojiDataModel get emojiDataModel => _emojiDataModel;

  Services services = Services();

  bool isLoading = true;

  TextEditingController textController = TextEditingController();

  Future<void> getEmojiData() async {
    isLoading = true;
    _emojiDataModel = await services.loadJsonAsset();
    final recentEmoji = await SharedPreferenceHelper.getRecentEmojiMaps();
    if (kDebugMode) {
      print(recentEmoji);
    }
    for (var element in recentEmoji) {
      _emojiDataModel.categories?[0].emojis?.add(element);
    }
    isLoading = false;
    notifyListeners();
  }

  onEmojiTap(int index, int emojiIndex) async {
    textController
      ..text +=
          emojiDataModel.categories?[index].emojis?[emojiIndex].emoji ?? ""
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    await SharedPreferenceHelper.setRecentEmojiMap(
        emojiDataModel.categories?[index].emojis?[emojiIndex], emojiDataModel);
    notifyListeners();
  }
}
