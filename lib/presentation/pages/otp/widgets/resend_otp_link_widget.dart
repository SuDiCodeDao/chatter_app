import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendOTPLinkWidget extends StatelessWidget {
  const ResendOTPLinkWidget({super.key, required this.onTap});
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: 'Không nhận được mã',
              style: TextStyle(fontSize: 16.sp, color: Colors.black)),
          const TextSpan(
            text: ' ',
          ),
          WidgetSpan(
              child: InkWell(
            onTap: onTap,
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
    );
  }
}
