import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import 'widgets/home_page_body_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();
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
      body: HomePageBodyWidget(
          homeController: _homeController, authController: _authController),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _homeController
                .createAndNavigateToChat(_authController.userEntity.uid!);
          },
          child: const Icon(Icons.add)),
    );
  }
}
