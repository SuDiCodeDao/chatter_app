import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/header_widget.dart';

class OTPPageBodyWidget extends StatelessWidget {
  const OTPPageBodyWidget({
    super.key,
    required AuthController authController,
  }) : _authController = authController;

  final AuthController _authController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const HeaderWidget(
                imagePath: 'asset/images/otp_authentication.png',
                title: 'Nhập mã OTP'),
            SizedBox(height: 20.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PinInputTextField(
                  controller: _authController.otpInputController,
                  decoration: UnderlineDecoration(
                    colorBuilder:
                        PinListenColorBuilder(Colors.black, Colors.blue),
                  ),
                  pinLength: 6,
                  onSubmit: (otp) {
                    _authController.otpInputController.text = otp;
                  },
                ),
                SizedBox(height: 20.h),
                ButtonWidget(
                    onPressed: () {
                      _authController
                          .verifyOTP(_authController.otpInputController.text);
                    },
                    text: 'Xác nhận'),
                SizedBox(height: 20.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'Không nhận được mã',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black)),
                      const TextSpan(
                        text: ' ',
                      ),
                      WidgetSpan(
                          child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Gửi lại ngay',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16.sp,
                              color: Colors.red),
                        ),
                      ))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
