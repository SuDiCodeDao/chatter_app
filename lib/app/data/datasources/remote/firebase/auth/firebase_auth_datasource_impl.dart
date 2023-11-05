import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../models/user_model.dart';
import 'firebase_auth_datasource.dart';

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth auth;
  String? smsCode;
  String? verificationId;

  FirebaseAuthDataSourceImpl({required this.auth});

  @override
  Future<UserModel> getCurrentUser() async {
    final user = auth.currentUser;
    return UserModel(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        phone: user?.phoneNumber,
        photoUrl: user?.photoURL);
  }

  @override
  Future<bool> isSignedIn() async {
    final user = await auth.authStateChanges().first;
    return user != null;
  }

  @override
  Future<String> resendOTP(String phoneNumber) {
    // TODO: implement resendOTP
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final emptyUserModel = UserModel(uid: '', email: '', displayName: '', phone: '', photoUrl: '');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        return UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          phone: user.phoneNumber,
          photoUrl: user.photoURL,
        );
      } else {
        return emptyUserModel;
      }
    } else {
      return emptyUserModel;
    }
  }

  @override
  Future<void> signOut() async {
    if (await isSignedIn()) {
      await auth.signOut();
    }
  }

  Stream<User?> get authStateChange => auth.authStateChanges();

  @override
  Future<UserModel> verifyOTP(String verificationCode) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: verificationCode);
    final userCredential = await auth.signInWithCredential(credential);
    final user = userCredential.user;
    return UserModel(
      uid: user!.uid,
      email: user.email,
      displayName: user.displayName,
      phone: user.phoneNumber,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<void> sendOTP(String phoneNumber) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Lỗi', 'Số điện thoại bạn cung cấp không hợp lệ');
          } else {
            Get.snackbar('Lỗi', 'Có lỗi xảy ra ở đâu đó');
          }
        },
        codeSent: (String? verificationId, resendToken) async {
          this.verificationId = verificationId;
          if (smsCode != null) {
            PhoneAuthCredential credential =
                PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: smsCode!);
            await auth.signInWithCredential(credential);
          } else {
            // Xử lý trường hợp smsCode là null
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  @override
  Future<void> deleteUser() async {
    auth.currentUser != null ? await auth.currentUser?.delete() : null;
  }

  @override
  Future<void> updateUserProfile(UserModel userModel) async {
    final user = auth.currentUser;
    if (user == null || userModel.email == null) {
      return;
    }

    user.updateEmail(userModel.email!);
    user.updateDisplayName(userModel.displayName!);
    user.updatePhotoURL(userModel.photoUrl);

    if (userModel.email != user.email) {
      await user.updateEmail(userModel.email!);
    }

    if (userModel.displayName != user.displayName) {
      await user.updateDisplayName(userModel.displayName);
    }

    if (userModel.photoUrl != user.photoURL) {
      await user.updatePhotoURL(userModel.photoUrl);
    }
  }
}
