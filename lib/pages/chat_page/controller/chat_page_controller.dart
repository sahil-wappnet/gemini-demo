import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/chat_page/chat_page.dart';
import 'package:get/state_manager.dart';



class chatPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  void handleSubmitted(String text) {
    textController.clear();
    final message = ChatMessage(
      text: text,
      isUser: true,
    );
    sendDataToServer(text);
    messages.insert(0, message);
  }

  void sendDataToServer(String question) async {
    const apiUrl =
        'https://generativelanguage.googleapis.com/v1beta3/models/text-bison-001:generateText?key=AIzaSyAMccb154fquBV4-0DQix1OQ9YShgX-IQU';

    try {
      final response = await Dio().post(
        apiUrl,
        data: {'prompt': {'text': question}},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final jsonResponse = jsonDecode(response.toString());
      final outputValue = jsonResponse['candidates'][0]['output'];
      final storedOutputValue = outputValue;
      handleResponse(storedOutputValue.toString());
      print("res : ${storedOutputValue.toString()}");
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  void handleResponse(String response) {
    final message = ChatMessage(
      text: response,
      isUser: false,
    );
    messages.insert(0, message);
  }
}
