import 'dart:convert';

import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:flutter/services.dart';

class Services {
  Future<EmojiDataModel> loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('assets/emoji_data.json');
    final response = jsonDecode(jsonString) as Map<String, dynamic>;
    return EmojiDataModel.fromJson(response);
  }
}
