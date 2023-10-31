import 'package:flutter/material.dart';

import '../../../../core/di/app_injection.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import 'widgets/home_page_body_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _homeController = locator<HomeController>();
  final _authController = locator<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Chatter Bot'),
          backgroundColor: Colors.lightBlueAccent,
          leading: IconButton(
            onPressed: () {},
            icon: ClipOval(
                child: Image.network(
              _authController.userEntity.value.photoUrl!,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            )),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ]),
      body: HomePageBodyWidget(
          homeController: _homeController,
          userId: _authController.userEntity.value.uid!),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _homeController
                .createAndNavigateToChat(_authController.userEntity.value.uid!);
          },
          child: const Icon(Icons.add)),
    );
  }
}
