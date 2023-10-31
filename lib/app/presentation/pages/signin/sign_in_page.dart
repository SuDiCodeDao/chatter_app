import 'package:flutter/material.dart';

import '../../../../core/di/app_injection.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/sign_in_page_body_widget.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final _authController = locator<AuthController>();
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SignInPageBodyWidget(
          formKey: formKey, authController: _authController),
    );
  }
}
