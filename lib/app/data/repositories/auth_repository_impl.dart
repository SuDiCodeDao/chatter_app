import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase/auth/firebase_auth_datasource.dart';
import '../datasources/remote/firebase/user/firebase_user_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final FirebaseUserDataSource firebaseUserDataSource;

  AuthRepositoryImpl(
      {required this.firebaseUserDataSource,
      required this.firebaseAuthDataSource});

  bool shouldUseFirestore = true;

  @override
  Future<void> deleteUser(String uid) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    var userModel = await firebaseAuthDataSource.signInWithGoogle();
    UserModel? existingUser =
        await firebaseUserDataSource.getUserByEmail(userModel.email!);
    if (existingUser != null) {
      existingUser.displayName = userModel.displayName;
      existingUser.photoUrl = userModel.photoUrl;
      await firebaseUserDataSource.updateUser(existingUser);
      return existingUser.toEntity();
    } else {
      if (shouldUseFirestore) {
        if (userModel.uid != '' && userModel.uid != null) {
          await firebaseUserDataSource.addUser(userModel);
        }
      }
      return userModel.toEntity();
    }
  }

  @override
  Future<void> signOut() {
    return firebaseAuthDataSource.signOut();
  }

  @override
  Future<void> updateUserProfile(UserEntity userEntity) async {
    UserModel userModel = UserModel.fromEntity(userEntity);
    await firebaseAuthDataSource.updateUserProfile(userModel);
    await firebaseUserDataSource.updateUser(userModel);
  }

  @override
  Future<UserEntity> verifyOTP(String verificationCode) async {
    UserModel userModel =
        await firebaseAuthDataSource.verifyOTP(verificationCode);

    UserModel? existingUserByEmail =
        await firebaseUserDataSource.getUserByEmail(userModel.email!);
    UserModel? existingUserByPhone =
        await firebaseUserDataSource.getUserByPhone(userModel.phone!);

    UserModel? existingUser = existingUserByEmail ?? existingUserByPhone;

    if (existingUser != null) {
      existingUser.displayName = userModel.displayName;
      existingUser.photoUrl = userModel.photoUrl;
      await firebaseUserDataSource.updateUser(existingUser);
      return existingUser.toEntity();
    } else {
      await firebaseUserDataSource.addUser(userModel);
      return userModel.toEntity();
    }
  }

  @override
  Future<void> sendOTP(String phoneNumber) async {
    await firebaseAuthDataSource.sendOTP(phoneNumber);
  }

  @override
  Future<bool> isSignedIn() async {
    return await firebaseAuthDataSource.isSignedIn();
  }
}
