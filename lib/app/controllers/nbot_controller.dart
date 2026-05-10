import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NBotController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var isResponding = false.obs;
  var chatMessages = <Map<String, String>>[].obs;

  final List<String> suggestions = [
    'what legal consequences will the man face next in this case',
    'what legal consequences will',
    'what legal consequences',
  ].obs;

  void onSuggestionTap(String suggestion) {
    textController.text = suggestion;
  }

  Future<void> sendMessage() async {
    final message = textController.text.trim();
    if (message.isEmpty) return;
    chatMessages.add({"sender": "user", "message": message});
    isResponding.value = true;
    textController.clear();
    await Future.delayed(const Duration(seconds: 2));
    chatMessages.add({"sender": "bot", "message": "This is a response from NBot."});
    isResponding.value = false;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}