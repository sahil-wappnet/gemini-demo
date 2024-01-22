import 'package:gemini_demo/model/user_local_details.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class ChatListingScreenController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Rx<User?> user = Rx<User?>(null);
  Map<String, dynamic>? storedUserData;
  UserLocalData? retrievedUserData;
  String? userName;


  @override
  void onInit() {
    storedUserData = GetStorage().read('userLocalData');
    if (storedUserData != null) {
      retrievedUserData = UserLocalData.fromMap(storedUserData!);
    }
    // user.bindStream(_auth.authStateChanges());
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     userName= user.displayName;
    //   } else {        
    //   }
    // });
    super.onInit();
  }

  navigateToNewChat(){
    Get.toNamed(ROUTE_CHATS_SCREEN);
  }

  // Future<void> signOut() async {
  //   await _auth.signOut();
  //   await _googleSignIn.signOut();
  // }
}
