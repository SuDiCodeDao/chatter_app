import 'package:chatter_app/app/data/datasources/local/shared_preferences/shared_datasource_impl.dart';
import 'package:chatter_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/di/app_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  final sharedDataSource = locator<SharedDataSourceImpl>();
  final isLoggedIn = await sharedDataSource.isLoggedIn();
  runApp(MainApp(isLoggedIn: isLoggedIn));
}
