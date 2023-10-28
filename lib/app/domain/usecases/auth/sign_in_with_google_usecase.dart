import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase({required this.authRepository});

  Future<UserEntity> call() {
    return authRepository.signInWithGoogle();
  }
}
