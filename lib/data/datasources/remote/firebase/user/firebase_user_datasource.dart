import '../../../../models/user_model.dart';

abstract class FirebaseUserDataSource {
  Future<void> addUser(UserModel userModel);
  Future<UserModel> getUser(String uid);

  Future<void> updateUser(UserModel userModel);

  Future<UserModel?> getUserByEmail(String email);

  Future<UserModel?> getUserByPhone(String phone);

  Future<void> deleteUser(String uid);
}
