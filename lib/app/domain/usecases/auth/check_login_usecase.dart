import '../../repositories/auth_repository.dart';

class CheckLoginUseCase {
  final AuthRepository authRepository;

  CheckLoginUseCase({required this.authRepository});

  Future<bool> call() {
    return authRepository.isSignedIn();
  }
}
