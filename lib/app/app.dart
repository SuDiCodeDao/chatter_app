import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:chatter_app/core/routes/app_route.dart';
import 'package:chatter_app/core/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 830),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return SafeArea(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Chatter Bot',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: ThemeMode.system,
                    initialRoute: user == null
                        ? PageRouteConstants.login
                        : PageRouteConstants.home,
                    getPages: AppRoute.route,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        );
      },
    );
  }
}
