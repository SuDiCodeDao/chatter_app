import 'package:chatter_app/app/domain/usecases/auth/check_login_usecase.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  SignInWithGoogleUseCase? _signInWithGoogleUseCase;
  SendOtpUseCase? _sendOtpUseCase;
  VerifyOTPUseCase? _verifyOTPUseCase;
  CheckLoginUseCase? _checkLoginUseCase;
  Rx<UserEntity> userEntity = UserEntity(
    uid: 'cIKzo1Op9UTdX6IJnYMEfjiC3mt2',
    email: 'sunguyen.dev@gmail.com',
    phone: '',
    photoUrl: 'https://lh3.googleusercontent.com/a/ACg8ocI2XE5ya--r7HUzz7WNEnPLP_klLCSOPt86hRUTa_zj=s96-c',
  ).obs;
  final otpInputController = TextEditingController();
  final phoneInputController = TextEditingController();

  AuthController({signInWithGoogleUseCase, sendOtpUseCase, verifyOTPUseCase, checkLoginUseCase}) {
    _signInWithGoogleUseCase = signInWithGoogleUseCase;
    _sendOtpUseCase = sendOtpUseCase;
    _verifyOTPUseCase = verifyOTPUseCase;
    _checkLoginUseCase = checkLoginUseCase;
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> sendOTP(String phoneNumber) async {
    if (phoneNumber.startsWith("0")) {
      phoneNumber = "+84${phoneNumber.substring(1)}";
    }
    isLoading.value = true;
    await _sendOtpUseCase!.call(phoneNumber);
    Get.toNamed(PageRouteConstants.otp);
    isLoading.value = false;
  }

  Future<UserEntity?> verifyOTP(String verificationCode) async {
    UserEntity? result = await _verifyOTPUseCase?.call(verificationCode);
    if (result != null) {
      userEntity.value = result;
      isLoading.value = true;
      Get.toNamed(PageRouteConstants.home);
      isLoading.value = false;
    }

    return null;
  }

  Future<void> checkLoginStatus() async {
    var result = await _checkLoginUseCase!.call();
    if (result) {
      isLoggedIn.value = false;
    } else {
      isLoggedIn.value = true;
    }
  }

  Future<void> signInWithGoogle() async {
    userEntity.value = await _signInWithGoogleUseCase!.call();
    if (userEntity.value.uid != null && userEntity.value.uid != '') {
      Get.toNamed(PageRouteConstants.home);
    }
  }
}
