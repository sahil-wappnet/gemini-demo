import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemini_demo/model/user_local_details.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> _storeUserDetails() async {
    final User? userValue = _auth.currentUser;
    
    if (userValue != null) {
      final DocumentReference userDoc = firestore.collection('users').doc(userValue.uid);
      
      await userDoc.set({
        'userId': userValue.uid,
        'displayName': userValue.displayName,
        'email': userValue.email,
      });
      UserLocalData userLocalData = UserLocalData(userName: _auth.currentUser!.displayName!, userId: userValue.uid, userEmail: _auth.currentUser!.email!, userPhotoUrl: _auth.currentUser!.photoURL!,);
      GetStorage().write('userLocalData', userLocalData.toMap());
    }
    
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) return;

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);
      await _storeUserDetails();
      Get.offAndToNamed(ROUTE_LISTING_CHATS_SCREEN);
    } catch (e) {
      log("$e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
