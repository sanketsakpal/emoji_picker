// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:emoji_picker/widgets/emoji_side_bar.dart';
import 'package:emoji_picker/widgets/emoji_tab_bar.dart';
import 'package:emoji_picker/widgets/emoji_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker/provider/emoji_picker_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  int _selectedTab = 0;

  late StreamSubscription<bool> keyboardSubscription;
  late TabController _tabController;
  late ScrollController _scrollController;

  final focusNode = FocusNode();

  bool isPortrait = false;
  double width = 0, height = 0;

  List<String> recentEmojis = [];

  final recentEmojiMap = {};
  List<String> messages = [];
  @override
  void initState() {
    super.initState();
    Provider.of<EmojiDataPickerProvider>(context, listen: false).getEmojiData();
    _tabController = TabController(vsync: this, length: 9);
    _scrollController = ScrollController();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && isEmojiVisible) {
        isEmojiVisible = false;
        setState(() {});
      } else {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isPortrait = height > width ? true : false;
    _tabController.addListener(() {
      _selectedTab = _tabController.index;
      if (!isPortrait) {
        _scrollController.jumpTo(_selectedTab * height * .075);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    Provider.of<EmojiDataPickerProvider>(context, listen: false)
        .textController
        .clear();
  }

  @override
  Widget build(BuildContext context) {
    final cross = (MediaQuery.of(context).size.width * .025).round();
    final emojiData = Provider.of<EmojiDataPickerProvider>(context);
    List<String> textMessage = List.of(messages.reversed);
    return Consumer<EmojiDataPickerProvider>(builder: (context, data, _) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            'Emoji Picker',
          ),
        ),
        body: data.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: isPortrait ? height : width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: textMessage.length,
                        itemBuilder: (context, index) => Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(8),
                            child: Text(textMessage[index]),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isEmojiVisible) {
                                focusNode.requestFocus();
                              } else if (!isEmojiVisible) {
                                await SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                await Future.delayed(
                                  const Duration(
                                    milliseconds: 100,
                                  ),
                                );
                                FocusScope.of(context).unfocus();
                              }
                              isEmojiVisible = !isEmojiVisible;
                              setState(() {});
                            },
                            icon: isEmojiVisible
                                ? const Icon(Icons.keyboard,
                                    color: Colors.black54)
                                : const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.black54,
                                  ),
                          ),
                          Flexible(
                            child: TextField(
                              focusNode: focusNode,
                              controller: data.textController,
                              decoration:
                                  const InputDecoration(hintText: 'Message...'),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              messages.add(data.textController.text);
                              data.textController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !isEmojiVisible,
                      child: Container(
                        height: height * .4,
                        width: double.infinity,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54, width: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DefaultTabController(
                          length: 9,
                          child: isPortrait
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(children: [
                                    EmojiTabBar(
                                      tabController: _tabController,
                                      emojiDataModel: emojiData.emojiDataModel,
                                    ),
                                    const Divider(
                                        color: Colors.black45,
                                        height: 5,
                                        thickness: .5),
                                    EmojisList(
                                      cross: cross,
                                      textController: data.textController,
                                      tabController: _tabController,
                                      emojiDataModel: emojiData.emojiDataModel,
                                      recentEmojis: recentEmojis,
                                    )
                                  ]),
                                )
                              : Row(
                                  children: [
                                    EmojiSideBar(
                                        controller: _scrollController,
                                        tabController: _tabController,
                                        selectedTab: _selectedTab,
                                        emojiDataModel: data.emojiDataModel),
                                    EmojisList(
                                      cross: cross,
                                      textController: data.textController,
                                      tabController: _tabController,
                                      emojiDataModel: data.emojiDataModel,
                                      recentEmojis: recentEmojis,
                                    )
                                  ],
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      );
    });
  }
}
