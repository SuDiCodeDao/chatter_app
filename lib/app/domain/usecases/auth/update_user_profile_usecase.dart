import 'package:chatter_app/app/domain/entities/user_entity.dart';
import 'package:chatter_app/app/domain/repositories/user_repository.dart';

import '../../repositories/auth_repository.dart';

class UpdateUserUseCase {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  UpdateUserUseCase(
      {required UserRepository userRepository,
      required AuthRepository authRepository})
      : _userRepository = userRepository,
        _authRepository = authRepository;

  Future<void> call(UserEntity userEntity) async {
    await _userRepository.updateUser(userEntity);
    await _authRepository.updateUserProfile(userEntity);
  }
}
