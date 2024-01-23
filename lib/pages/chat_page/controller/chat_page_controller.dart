import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gemini_demo/model/user_local_details.dart';
import 'package:gemini_demo/pages/chat_page/chat_page.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class chatPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? chatId;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  Map<String, dynamic>? storedUserData;
  UserLocalData? retrievedUserData;

  @override
  void onInit() {
    storedUserData = GetStorage().read('userLocalData');
    if (storedUserData != null) {
      retrievedUserData = UserLocalData.fromMap(storedUserData!);
    }
    super.onInit();
  }

  void handleSubmitted(String text) {
    textController.clear();
    final message = ChatMessage(
      userImage: retrievedUserData!.userPhotoUrl,
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
        data: {
          'prompt': {'text': question}
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final jsonResponse = jsonDecode(response.toString());
      final outputValue = jsonResponse['candidates'][0]['output'];
      final storedOutputValue = outputValue;
      handleResponse(storedOutputValue.toString());
      // print("res : ${storedOutputValue.toString()}");
      String imageLoc = "";

 // final messageDoc = messagesCollection.doc();
      // final messageId = messageDoc.id;

      final messagesCollection = firestore.collection('users').doc(retrievedUserData!.userId).collection('chat_$chatId').doc();
      await messagesCollection.set({
        'image-location': imageLoc,
        'questionText': question,
        'answerText': storedOutputValue.toString(),        
        'createdAt': Timestamp.now(),
        'messageId': messagesCollection.id,
      });
      
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  void handleResponse(String response) {
    final message = ChatMessage(
      userImage: retrievedUserData!.userPhotoUrl,
      text: response,
      isUser: false,
    );
    messages.insert(0, message);
  }
}
