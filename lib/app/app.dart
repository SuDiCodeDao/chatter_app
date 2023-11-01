import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:chatter_app/core/routes/app_route.dart';
import 'package:chatter_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.isLoggedIn});
  final bool? isLoggedIn;
  @override
  Widget build(BuildContext context) {
    final bool isUserLoggedIn = isLoggedIn ?? false;
    return ScreenUtilInit(
        designSize: const Size(393, 830),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return SafeArea(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chatter Bot',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              initialRoute: isUserLoggedIn
                  ? PageRouteConstants.home
                  : PageRouteConstants.login,
              getPages: AppRoute.route,
            ),
          );
        });
  }
}
