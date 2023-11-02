import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/di/app_injection.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/otp_page_body_widget.dart';

class OTPInputPage extends StatelessWidget {
  OTPInputPage({super.key});
  final _authController = locator<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.w,
        leading: InkWell(
            onTap: () {
              Get.toNamed(PageRouteConstants.login);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.red)),
      ),
      body: OTPPageBodyWidget(authController: _authController),
    );
  }
}
