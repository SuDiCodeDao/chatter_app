import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/header_widget.dart';
import 'otp_form_widget.dart';

class OTPPageBodyWidget extends StatelessWidget {
  const OTPPageBodyWidget({
    super.key,
  });

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
            OTPFormWidget(),
          ],
        ),
      ),
    );
  }
}
