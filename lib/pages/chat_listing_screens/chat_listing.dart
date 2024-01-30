import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/chat_listing_screens/controller/chat_listing_controller.dart';
import 'package:gemini_demo/utils/responsive.dart';
import 'package:get/get.dart';

class ChatListingScreen extends StatelessWidget {
  const ChatListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

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
                                'Welcome,\n${controller.retrievedUserData!.userName}',
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
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: controller.retrievedUserData!
                                            .userPhotoUrl.isEmpty
                                        ? Text(
                                            'S',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: hp(3)),
                                          )
                                        : Image.network(
                                            controller.retrievedUserData!
                                                .userPhotoUrl,
                                            fit: BoxFit.cover,
                                          ))),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: wp(4)),
                        child: SizedBox(
                          height: hp(85),
                          // child: ListView.builder(
                          //     itemCount: 1,
                          //     itemBuilder: ((context, index) {
                          //       return Card(
                          //           child: Container(
                          //         margin: EdgeInsets.symmetric(
                          //             vertical: hp(1), horizontal: wp(2)),
                          //         child: Row(
                          //           children: [
                          //             Text(
                          //               'New Chat',
                          //               style: TextStyle(fontSize: hp(2)),
                          //             ),
                          //           ],
                          //         ),
                          //       ));
                          //     })),
                          child: FutureBuilder<QuerySnapshot>(
                            future: collectionRef.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(child: SizedBox(height: 45,width: 45,child: CircularProgressIndicator(),));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  log("Data : ${data.length}");
                                  return const ListTile(
                                    title: Text(''),
                                    subtitle: Text(''),
                                  );
                                }).toList());
                              }
                            },
                          ),
                        )),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  // controller.signOut();
                  controller.navigateToNewChat();
                },
                icon: const Icon(Icons.add),
                label: const Text('New chat'),
              ));
        });
  }
}
