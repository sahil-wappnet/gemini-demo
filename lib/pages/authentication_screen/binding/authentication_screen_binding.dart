import 'package:get/get.dart';
import '../controller/authentication_controller.dart';

class AuthenticationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationScreenController>(
      () => AuthenticationScreenController(),
    );
  }
}
