import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/chat_listing.dart/controller/chat_listing_controller.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:gemini_demo/utils/responsive.dart';
import 'package:get/get.dart';

class ChatListingScreen extends StatelessWidget {
  const ChatListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListingScreenController>(
        init: ChatListingScreenController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: wp(3.5), vertical: hp(1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Welcome,\nSahil Chudasama',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: hp(2)),
                              ),
                            ],
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                            height: hp(6.5),
                            width: wp(13),
                            child: Center(
                                child: Text(
                              'S',
                              style: TextStyle(
                                  color: Colors.white, fontSize: hp(3)),
                            )),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: wp(4)),
                        child: SizedBox(
                      height: hp(85),
                      child: ListView.builder(
                          itemCount: 100,
                          itemBuilder: ((context, index) {
                            return Card(child: Container(
                              margin: EdgeInsets.symmetric(vertical: hp(1),horizontal: wp(2)),
                              child: Row(
                                children: [
                                  Text('Name',style: TextStyle(fontSize: hp(2)),),
                                ],
                              ),
                            ));
                          })),
                    )),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Get.toNamed(ROUTE_CHATS_SCREEN);
                },
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
              ));
        });
  }
}
