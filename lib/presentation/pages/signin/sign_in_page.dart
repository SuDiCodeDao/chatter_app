import 'package:flutter/material.dart';

import 'widgets/sign_in_page_body_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: true,
        body: Scaffold(
          body: SignInPageBodyWidget(),
        ));
  }
}
