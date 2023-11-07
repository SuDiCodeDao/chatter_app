import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_flutter/icons_flutter.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'phone_input_form_widget.dart';

class SignInFormWidget extends StatelessWidget {
  const SignInFormWidget({
    super.key,
    required this.formKey,
    required AuthController authController,
  }) : _authController = authController;

  final GlobalKey<FormState> formKey;
  final AuthController _authController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Obx(
        () => Stack(children: [
          Column(
            children: [
              PhoneInputFormWidget(
                hintText: 'Nhập số điện thoại',
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  _authController.phoneInputController.text = value;
                },
                controller: _authController.phoneInputController,
              ),
              SizedBox(height: 20.h),
              ButtonWidget(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _authController.sendOTP(
                          _authController.phoneInputController.text.trim());
                    }
                  },
                  icon: Icons.arrow_forward_ios,
                  text: 'Đăng nhập với OTP'),
              SizedBox(height: 10.h),
              Text(
                ' ------- hoặc -------',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () {
                  _authController.signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent, // Màu nền của nút
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Hình dáng của nút
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Row(children: [
                  Icon(AntDesign.google),
                  SizedBox(width: 10),
                  Expanded(child: Text('Đăng nhập với Google'))
                ]),
              ),
              if (_authController.isLoading.value)
                const Positioned.fill(child: LoadingWidget())
            ],
          ),
        ]),
      ),
    );
  }
}
