import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/chat_page/controller/chat_page_controller.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<chatPageController>(
        init: chatPageController(),
        builder: (controller) {
          controller.chatId = Get.arguments;
          return Scaffold(
            body: Column(
              children: <Widget>[
                Flexible(
                  child: Obx(
                    () => ListView.builder(
                      reverse: true,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) =>
                          controller.messages[index],
                    ),
                  ),
                ),
                
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(context, controller),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTextComposer(BuildContext context, controller) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: controller.textController,
                // onSubmitted: (){controller.uploadImageToFirebase();},
                // onSubmitted: controller.handleSubmitted,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attachment),
                    onPressed: () {
                      controller.pickImageFromGallery();
                    },
                  ),
                ),
              ),
            ),
            IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      controller
                        .handleSubmitted(controller.textController.text);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String userImage;
  final String text;
  final bool isUser;


  const ChatMessage({Key? key, required this.text, required this.isUser,required this.userImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container()
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CircleAvatar(
                    child: Image.asset('assets/google.png'),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                isUser
                    ? const Text('You',
                        style: TextStyle(fontWeight: FontWeight.bold))
                    : const Text('Google Gemini',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  
                  margin: const EdgeInsets.only(top: 4.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
          !isUser
              ? Container()
              : Container(
                
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(userImage)),
                  ),
                ),
        ],
      ),
    );
  }
}
