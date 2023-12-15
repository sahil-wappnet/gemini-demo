import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatListingScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Rx<User?> user = Rx<User?>(null);
  String? userName;


  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is already logged in, redirect to Home Page
        userName= user.displayName;
      } else {
        // User is not logged in, redirect to Authentication Page
      }
    });
    super.onInit();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
