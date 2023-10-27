import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();

  Future<void> sendOTP(String phoneNumber);

  Future<void> updateUserProfile(UserEntity userEntity);

  Future<void> deleteUser(String uid);
  Future<UserEntity> verifyOTP(String verificationCode);
}
