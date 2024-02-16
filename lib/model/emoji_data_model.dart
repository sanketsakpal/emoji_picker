// ignore_for_file: public_member_api_docs, sort_constructors_first
class EmojiDataModel {
  List<Categories>? categories;

  EmojiDataModel({this.categories});

  EmojiDataModel.fromJson(Map<String, dynamic> json) {
    categories = json["categories"] == null
        ? null
        : (json["categories"] as List)
            .map((e) => Categories.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    return data;
  }

  EmojiDataModel copyWith({
    List<Categories>? categories,
  }) =>
      EmojiDataModel(
        categories: categories ?? this.categories,
      );

  @override
  String toString() => 'EmojiDataModel(categories: $categories)';
}

class Categories {
  String? name;
  String? categoryNameEmoji;
  List<Emojis>? emojis;

  Categories({
    this.name,
    this.emojis,
    this.categoryNameEmoji,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    categoryNameEmoji = json["category_name_emoji"];
    emojis = json["emojis"] == null
        ? null
        : (json["emojis"] as List).map((e) => Emojis.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["category_name_emoji"] = categoryNameEmoji;
    if (emojis != null) {
      data["emojis"] = emojis?.map((e) => e.toJson()).toList();
    }
    return data;
  }

  Categories copyWith({
    String? name,
    String? categoryNameEmoji,
    List<Emojis>? emojis,
  }) =>
      Categories(
        name: name ?? this.name,
        categoryNameEmoji: categoryNameEmoji ?? this.categoryNameEmoji,
        emojis: emojis ?? this.emojis,
      );

  @override
  String toString() => 'Categories(name: $name, categoryNameEmoji: $categoryNameEmoji, emojis: $emojis)';
}

class Emojis {
  int? id;
  String? emojiCode;
  String? emoji;
  String? description;

  Emojis({this.id, this.emojiCode, this.emoji, this.description});

  Emojis.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int?;
    emojiCode = json["emoji_code"] as String?;
    emoji = json["emoji"] as String?;
    description = json["description"] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["emoji_code"] = emojiCode;
    data["emoji"] = emoji;
    data["description"] = description;
    return data;
  }

  Emojis copyWith({
    int? id,
    String? emojiCode,
    String? emoji,
    String? description,
  }) =>
      Emojis(
        id: id ?? this.id,
        emojiCode: emojiCode ?? this.emojiCode,
        emoji: emoji ?? this.emoji,
        description: description ?? this.description,
      );

  @override
  String toString() {
    return 'Emojis(id: $id, emojiCode: $emojiCode, emoji: $emoji, description: $description)';
  }
}
