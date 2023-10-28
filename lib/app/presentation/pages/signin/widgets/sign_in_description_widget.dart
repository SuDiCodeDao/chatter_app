import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInDescriptionWidget extends StatelessWidget {
  const SignInDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),
      child: Text(
        'Chúng tôi sẽ gửi cho bạn 1 mã OTP qua số điện thoại của bạn',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
