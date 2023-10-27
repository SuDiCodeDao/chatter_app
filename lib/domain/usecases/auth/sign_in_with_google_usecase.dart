import 'package:chatter_app/domain/repositories/auth_repository.dart';

import '../../entities/user_entity.dart';

class SignInWithGoogleUseCase {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase({required this.authRepository});

  Future<UserEntity> call() {
    return authRepository.signInWithGoogle();
  }
}
