import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/authentication_screen/controller/authentication_controller.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:gemini_demo/utils/responsive.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationScreenController>(
        init: AuthenticationScreenController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: hp(2.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: hp(15),
                      ),
                      Text(
                        'Gemini',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: hp(5),
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  Center(
                    child: Obx(
                      () => controller.user.value != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Welcome, ${controller.user.value!.displayName}'),
                                ElevatedButton(
                                  onPressed: () async {
                                    await controller.signOut();
                                  },
                                  child: const Row(
                                    children: [
                                      Text('Sign Out'),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.all(hp(2)),
                              child: Card(
                                elevation: 1,
                                color: Colors.white,
                                child: Container(
                                  width: wp(50),                                  
                                  padding: EdgeInsets.symmetric(vertical: hp(1),horizontal: wp(2)),
                                  child: InkWell(
                                    onTap: () {
                                      Get.offAndToNamed(ROUTE_LISTING_CHATS_SCREEN);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/google.png',
                                          height: hp(3),
                                        ),
                                        SizedBox(
                                          width: wp(2.5),
                                        ),
                                        const Text('Sign In with Google',style: TextStyle(color: Colors.black87),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
