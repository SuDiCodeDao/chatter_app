import 'package:chatter_app/app/domain/repositories/user_repository.dart';

import '../../entities/user_entity.dart';

class GetUserByConversationIdUseCase {
  final UserRepository userRepository;

  GetUserByConversationIdUseCase({required this.userRepository});
  Future<UserEntity?> call(String conversationId) async {
    return await userRepository.getUserByConversationId(conversationId);
  }
}
