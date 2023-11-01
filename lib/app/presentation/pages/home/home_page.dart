import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: Text(''),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Thông tin người dùng'),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Hướng dẫn sử dụng'),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('Về ứng dụng'),
            ),
            ListTile(
              onTap: () {
                _homeController.signOut();
              },
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
            )
          ],
        ),
      ),
      appBar: AppBar(
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
                  width: 40,
                  height: 40,
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
          ]),
      body: HomePageBodyWidget(
          homeController: _homeController,
          userId: _authController.userEntity.value.uid!),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            _homeController
                .createAndNavigateToChat(_authController.userEntity.value.uid!);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
