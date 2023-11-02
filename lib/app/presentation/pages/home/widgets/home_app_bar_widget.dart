import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({
    super.key,
    required AuthController authController,
    required HomeController homeController,
  })  : _authController = authController,
        _homeController = homeController;

  final AuthController _authController;
  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: const Text('Chatter Bot'),
        backgroundColor: Colors.lightBlueAccent,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: ClipOval(
              child: Image.network(
                _authController.userEntity.value.photoUrl!,
                fit: BoxFit.cover,
                width: 40.w,
                height: 40.h,
              ),
            ),
          );
        }),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Obx(
            () => IconButton(
                onPressed: () {
                  _homeController.toggleDarkMode();
                },
                icon: _homeController.isDarkMode.value
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode)),
          ),
        ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
