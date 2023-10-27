import 'package:chatter_app/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _authRepository;

  SendOtpUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call(String phoneNumber) async {
    await _authRepository.sendOTP(phoneNumber);
  }
}
