import 'package:chatter_app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPInputFormWidget extends StatelessWidget {
  OTPInputFormWidget({
    super.key,
  });
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return PinInputTextField(
      controller: _authController.otpInputController,
      decoration: UnderlineDecoration(
        colorBuilder: PinListenColorBuilder(Colors.black, Colors.blue),
      ),
      pinLength: 6,
      onSubmit: (otp) {
        _authController.otpInputController.text = otp;
      },
    );
  }
}
