import 'package:chatter_app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/home_page_body_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: const Icon(Icons.menu),
          actions: [
            IconButton(
                onPressed: () {},
                icon: _authController.userEntity.photoUrl != null
                    ? Image.network(
                        _authController.userEntity.photoUrl!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.person)),
          ]),
      body: HomePageBodyWidget(),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
