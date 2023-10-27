import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:chatter_app/domain/entities/user_entity.dart';
import 'package:chatter_app/domain/usecases/auth/send_otp_usecase.dart';
import 'package:chatter_app/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:chatter_app/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  SignInWithGoogleUseCase? _signInWithGoogleUseCase;
  SendOtpUseCase? _sendOtpUseCase;
  VerifyOTPUseCase? _verifyOTPUseCase;
  UserEntity userEntity = UserEntity();
  final otpInputController = TextEditingController();
  final phoneInputController = TextEditingController();
  AuthController({signInWithGoogleUseCase, sendOtpUseCase, verifyOTPUseCase}) {
    _signInWithGoogleUseCase = signInWithGoogleUseCase;
    _sendOtpUseCase = sendOtpUseCase;
    _verifyOTPUseCase = verifyOTPUseCase;
  }

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
    isLoading.value = true;
    UserEntity? result = await _verifyOTPUseCase?.call(verificationCode);
    if (result != null) {
      userEntity = result;
      Get.toNamed(PageRouteConstants.home);
    }
    isLoading.value = false;
    return null;
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    userEntity = await _signInWithGoogleUseCase!.call();

    Get.toNamed(PageRouteConstants.home);
    isLoading.value = false;
  }
}
