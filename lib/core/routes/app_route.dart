import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:get/get.dart';

import '../../app/presentation/pages/chat/chat_page.dart';
import '../../app/presentation/pages/home/home_page.dart';
import '../../app/presentation/pages/otp/otp_page.dart';
import '../../app/presentation/pages/signin/sign_in_page.dart';

class AppRoute {
  static final route = [
    GetPage(name: PageRouteConstants.login, page: () => SignInPage()),
    GetPage(name: PageRouteConstants.otp, page: () => OTPInputPage()),
    GetPage(name: PageRouteConstants.home, page: () => HomePage()),
    GetPage(name: PageRouteConstants.chat, page: () => ChatPage())
  ];
}
