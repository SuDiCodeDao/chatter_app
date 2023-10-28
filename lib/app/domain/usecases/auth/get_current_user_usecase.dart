import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _userRepository;

  GetCurrentUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<UserEntity> call(String userId) async {
    return await _userRepository.getUser(userId);
  }
}
