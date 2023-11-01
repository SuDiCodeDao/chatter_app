abstract class SharedDatasource {
  Future<String?> getLanguage();

  Future<void> setLanguage(String language);

  Future<void> saveLoginStatus(bool isLoggedIn);

  Future<bool> isLoggedIn();

  Future<void> setDarkMode(bool isDarkMode);

  Future<bool> isDarkMode();
}
