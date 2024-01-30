// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gemini_demo/model/user_local_details.dart';
import 'package:gemini_demo/pages/chat_page/chat_page.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class chatPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? chatId;
  File? imageFile;
  String? downloadUrl;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  Map<String, dynamic>? storedUserData;
  UserLocalData? retrievedUserData;

  @override
  void onInit() {
    // makeApiRequest();
    storedUserData = GetStorage().read('userLocalData');
    if (storedUserData != null) {
      retrievedUserData = UserLocalData.fromMap(storedUserData!);
    }
    super.onInit();
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        geminiVisionApi();
        //  uploadImageToFirebase();
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> uploadImageToFirebase() async {
    try {
      if (imageFile == null) {
        log('No image selected.');
        return;
      }

      final storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child(
          'images/${retrievedUserData!.userId}/${DateTime.now().toIso8601String()}.jpeg');
      final UploadTask uploadTask = storageRef.putFile(
          imageFile!,
          SettableMetadata(
            contentType: "image/jpeg",
          ));

      await uploadTask.whenComplete(() async {
        log('Image uploaded to Firebase Storage');
        downloadUrl = await storageRef.getDownloadURL();
        log('Download URL: $downloadUrl');
        // geminiVisionApi();
      });
    } catch (e) {
      log('Error uploading image to Firebase Storage: $e');
    }
  }

  void geminiVisionApi() async {
    final imageData = await File(imageFile!.path).readAsBytes();
    String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyAMccb154fquBV4-0DQix1OQ9YShgX-IQU";
    var response = await Dio().post(
      apiUrl,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "What is this picture?"},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Encode(imageData),
                }
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      String jsonData = response.toString();      
      Map<String, dynamic> data = json.decode(jsonData);
      List<dynamic> parts = data['candidates'][0]['content']['parts'];
      String extractedText = parts[0]['text'];      
      print(extractedText);
    } else {
      
      print("HTTP Request failed with status code ${response.statusCode}");
    }
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
      String imageLoc = "";

      final chatsCollection = firestore
          .collection('users')
          .doc(retrievedUserData!.userId)
          .collection('chats');

      final chatDoc = chatsCollection.doc('chat_$chatId');

      final messegeCollection = chatDoc.collection('messages');
      Timestamp timestamp = Timestamp.now();
      String uniqueMessageId = '${timestamp.seconds}${timestamp.nanoseconds}';
      final messgeDoc = messegeCollection.doc("mes_$uniqueMessageId");
      final messageId = messgeDoc.id;

      await messgeDoc.set({
        'image-location': imageLoc,
        'questionText': question,
        'answerText': storedOutputValue.toString(),
        'createdAt': Timestamp.now(),
        'messageId': messageId,
      });
    } catch (e) {
      log('Error sending data: $e');
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
