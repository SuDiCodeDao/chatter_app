import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository _authRepository;

  VerifyOTPUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<UserEntity> call(String verificationCode) async {
    return _authRepository.verifyOTP(verificationCode);
  }
}
