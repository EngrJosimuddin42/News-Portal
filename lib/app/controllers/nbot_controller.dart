import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NBotController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var isResponding = false.obs;
  var chatMessages = <Map<String, String>>[].obs;

  final List<String> suggestions = [
    'what legal consequences will the man face next in this case',
    'what legal consequences will',
    'what legal consequences',
  ].obs;

  void onSuggestionTap(String suggestion) {
    textController.text = suggestion;
    sendMessage();
  }

  Future<void> sendMessage() async {
    final message = textController.text.trim();
    if (message.isEmpty) return;

    chatMessages.add({"sender": "user", "message": message});
    isResponding.value = true;
    textController.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));
    
    chatMessages.add({"sender": "bot", "message": "This is a response from NBot."});
    isResponding.value = false;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
