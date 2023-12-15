import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/splash_screen/binding/controller/splash_controller.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:gemini_demo/utils/responsive.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      initState: (_) {},
      builder: (controller) {
        return FutureBuilder(
          future: controller.initializeSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            } else {
              if (snapshot.hasError) {
                return errorView(snapshot);
              } else if (snapshot.connectionState == ConnectionState.done) {
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    Get.offAndToNamed(ROUTE_AUTH_SCREEN);
                  },
                );
              }
            }
            return Scaffold(
              body: Center(
                  child: Column(
                    mainAxisAlignment :MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: hp(17),
                      ),
                      Text('Gemini',style: TextStyle(color: Colors.grey,fontSize: hp(5),fontWeight: FontWeight.w400),)
                    ],
                  ),
                  
               ),
            );
          },
        );
      },
    );
  }
}

Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
  return Scaffold(
    body: Center(
      child: Text('Error: ${snapshot.error}'),
    ),
  );
}
