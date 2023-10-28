import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/header_widget.dart';
import 'sign_in_description_widget.dart';
import 'sign_in_form_widget.dart';

class SignInPageBodyWidget extends StatelessWidget {
  const SignInPageBodyWidget({
    super.key,
    required this.formKey,
    required AuthController authController,
  }) : _authController = authController;

  final GlobalKey<FormState> formKey;
  final AuthController _authController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          const HeaderWidget(
              imagePath: 'asset/images/human.png', title: 'ĐĂNG NHẬP'),
          SizedBox(
            height: 10.h,
          ),
          const SignInDescriptionWidget(),
          SizedBox(
            height: 10.h,
          ),
          SignInFormWidget(formKey: formKey, authController: _authController),
        ],
      ),
    );
  }
}
