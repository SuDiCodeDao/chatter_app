import 'package:chatter_app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import 'otp_input_form_widget.dart';
import 'resend_otp_link_widget.dart';

class OTPFormWidget extends StatelessWidget {
  OTPFormWidget({super.key});
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OTPInputFormWidget(),
        SizedBox(height: 20.h),
        ButtonWidget(
            onPressed: () {
              _authController
                  .verifyOTP(_authController.otpInputController.text);
            },
            text: 'Xác nhận'),
        SizedBox(height: 20.h),
        ResendOTPLinkWidget(
          onTap: () {
            _authController.sendOTP(_authController.phoneInputController.text);
          },
        ),
      ],
    );
  }
}
