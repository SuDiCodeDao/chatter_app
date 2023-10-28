import '../../entities/conversation_entity.dart';
import '../../repositories/conversation_repository.dart';

class LoadConversationsUseCase {
  final ConversationRepository _conversationRepository;

  LoadConversationsUseCase(
      {required ConversationRepository conversationRepository})
      : _conversationRepository = conversationRepository;

  Future<List<ConversationEntity>> call(String userId) async {
    return await _conversationRepository.getConversationsForUser(userId);
  }
}
