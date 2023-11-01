import 'package:chatter_app/app/data/datasources/local/shared_preferences/shared_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedDataSourceImpl extends SharedDatasource {
  final SharedPreferences sharedPreferences;

  SharedDataSourceImpl({required this.sharedPreferences});
  @override
  Future<String?> getLanguage() async {
    return sharedPreferences.getString('language');
  }

  @override
  Future<bool> isDarkMode() async {
    return sharedPreferences.getBool('darkMode') ?? false;
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool('isLoggedIn') ?? false;
  }

  @override
  Future<void> saveLoginStatus(bool isLoggedIn) {
    return sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Future<void> setDarkMode(bool isDarkMode) {
    return sharedPreferences.setBool('darkMode', isDarkMode);
  }

  @override
  Future<void> setLanguage(String language) async {
    await sharedPreferences.setString('language', language);
  }
}
