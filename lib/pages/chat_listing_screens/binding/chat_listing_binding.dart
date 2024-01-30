import 'package:gemini_demo/pages/chat_listing_screens/controller/chat_listing_controller.dart';
import 'package:get/get.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatListingScreenController>(
      () => ChatListingScreenController(),
    );
  }
}