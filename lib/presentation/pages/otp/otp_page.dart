import 'package:chatter_app/presentation/pages/signin/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/otp_page_body_widget.dart';

class OTPInputPage extends StatelessWidget {
  const OTPInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.to(const SignInPage());
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.red)),
      ),
      body: const OTPPageBodyWidget(),
    );
  }
}
