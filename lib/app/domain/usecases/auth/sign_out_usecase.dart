import 'package:chatter_app/app/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
