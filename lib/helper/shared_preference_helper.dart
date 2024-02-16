import 'dart:convert';

import 'package:emoji_picker/model/emoji_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPreferenceHelper {
  static const int maxRecentEmojis = 10;

  static Future<void> setRecentEmojiMap(
      Emojis? value, EmojiDataModel emojiDataModel) async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();

      // Retrieve the current list of recent emojis
      List<Emojis> recentEmojis = await getRecentEmojiMaps();

      // Check if the emoji already exists in the list
      Emojis? existingEmoji;
      Emojis? duplicateEmojis;

      try {
        existingEmoji =
            recentEmojis.firstWhere((emoji) => emoji.id == value?.id);

        duplicateEmojis = emojiDataModel.categories?[0].emojis
            ?.firstWhere((element) => element.id == value?.id);
      } catch (e) {
        existingEmoji =
            null; // If no matching element is found, set existingEmoji to null
      }

      // If the emoji already exists, remove it from the list
      if (existingEmoji != null && duplicateEmojis != null) {
        recentEmojis.remove(existingEmoji);
        emojiDataModel.categories?[0].emojis?.remove(duplicateEmojis);
      }

      // Add the new emoji to the beginning of the list
      recentEmojis.insert(0, value!);
      emojiDataModel.categories?[0].emojis?.insert(0, value);
      // Ensure the list doesn't exceed the maximum limit
      if (recentEmojis.length > maxRecentEmojis &&
          emojiDataModel.categories![0].emojis!.length > maxRecentEmojis) {
        recentEmojis = recentEmojis.sublist(0, maxRecentEmojis);
        emojiDataModel.categories?[0].emojis?.sublist(0, maxRecentEmojis);
      }

      // Convert the list of Emojis objects to a list of JSON strings
      final List<String> jsonList =
          recentEmojis.map((emoji) => jsonEncode(emoji.toJson())).toList();

      // Save the list of JSON strings to SharedPreferences

      await prefs.setStringList("RecentEmojiMaps", jsonList);
      if (kDebugMode) {
        print('Recent Emoji Map saved to SharedPreferences');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<List<Emojis>> getRecentEmojiMaps() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();

      final List<String>? jsonList = prefs.getStringList("RecentEmojiMaps");
      if (jsonList != null) {
        // Convert the list of JSON strings to a list of Emojis objects
        final List<Emojis> emojisList = jsonList.map((jsonString) {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          return Emojis.fromJson(jsonMap);
        }).toList();
        return emojisList;
      } else {
        return []; // Return an empty list if the key doesn't exist or the stored value is null
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
