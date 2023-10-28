import 'package:chatter_app/app/presentation/controllers/auth_controller.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:chatter_app/core/routes/app_route.dart';
import 'package:chatter_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    _authController.checkLoginStatus();

    return ScreenUtilInit(
      designSize: const Size(393, 830),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return SafeArea(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: _authController.isLoggedIn.value
                ? PageRouteConstants.home
                : PageRouteConstants.login,
            getPages: AppRoute.route,
          ),
        );
      },
    );
  }
}
