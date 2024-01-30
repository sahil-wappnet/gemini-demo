import 'package:gemini_demo/pages/authentication_screen/authentication_screen.dart';
import 'package:gemini_demo/pages/authentication_screen/binding/authentication_screen_binding.dart';
import 'package:gemini_demo/pages/chat_listing_screens/binding/chat_listing_binding.dart';
import 'package:gemini_demo/pages/chat_listing_screens/chat_listing.dart';
import 'package:gemini_demo/pages/chat_page/binding/chat_page_binding.dart';
import 'package:gemini_demo/pages/chat_page/chat_page.dart';
import 'package:gemini_demo/routes/app_route.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final routePages = [
  GetPage(
    name: ROUTE_LISTING_CHATS_SCREEN,
    page: () =>  const ChatListingScreen(),
    binding: ChatScreenBinding(),
  ),
  GetPage(
    name: ROUTE_CHATS_SCREEN,
    page: () =>  const ChatScreen(),
    binding: ChatBinding(),
  ),
  GetPage(
    name: ROUTE_AUTH_SCREEN,
    page: () =>  const AuthenticationScreen(),
    binding: AuthenticationScreenBinding(),
  ),
];