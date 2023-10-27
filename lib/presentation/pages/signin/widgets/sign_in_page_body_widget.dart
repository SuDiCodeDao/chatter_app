import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/header_widget.dart';
import 'sign_in_description_widget.dart';
import 'sign_in_form_widget.dart';

class SignInPageBodyWidget extends StatelessWidget {
  const SignInPageBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: SingleChildScrollView(
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
            SignInFormWidget(formKey: GlobalKey<FormState>()),
          ],
        ),
      ),
    );
    ;
  }
}
