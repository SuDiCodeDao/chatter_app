import '../../../../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<void> sendOTP(String phoneNumber);

  Future<void> signOut();

  Future<UserModel> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<UserModel> getCurrentUser();

  Future<bool> isSignedIn();

  Future<UserModel> verifyOTP(String verificationCode);

  Future<String> resendOTP(String phoneNumber);
  Future<void> updateUserProfile(UserModel userModel);
  Future<void> deleteUser();
}
