import 'package:flutter/material.dart';

import '../../../../core/di/app_injection.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import 'widgets/home_app_bar_widget.dart';
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
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Image.network(
                          _authController.userEntity.value.photoUrl!),
                    ),
                    Text(
                      _authController.userEntity.value.displayName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.live_help),
              title: Text('Điều khoản và quyền riêng tư'),
            ),
            ListTile(
              onTap: () => showAppInfoDialog(context),
              leading: const Icon(Icons.info),
              title: const Text('Về ứng dụng'),
            ),
            ListTile(
              onTap: () {
                _homeController.signOut();
              },
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
            ),
            const ListTile(
              leading: Icon(Icons.no_accounts),
              title: Text('Xóa tài khoản'),
            ),
          ],
        ),
      ),
      appBar: HomeAppBarWidget(
          authController: _authController, homeController: _homeController),
      body: HomePageBodyWidget(
          homeController: _homeController,
          userId: _authController.userEntity.value.uid!),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () async {
            await _homeController
                .createAndNavigateToChat(_authController.userEntity.value.uid!);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  void showAppInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AboutDialog(
            applicationName: 'Chatter Bot',
            applicationIcon: Icon(Icons.add),
            applicationVersion: '1.0.0',
            applicationLegalese:
                'Chatter Bot là ứng dụng trò chuyện thông minh được phát triển bởi tôi',
          );
        });
  }
}
