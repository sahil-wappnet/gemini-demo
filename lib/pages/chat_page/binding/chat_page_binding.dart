import 'package:gemini_demo/pages/chat_page/controller/chat_page_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<chatPageController>(
      () => chatPageController(
        
      ),
    );
  }
}
