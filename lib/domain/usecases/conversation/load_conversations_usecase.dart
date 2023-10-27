import 'package:chatter_app/domain/entities/conversation_entity.dart';
import 'package:chatter_app/domain/repositories/conversation_repository.dart';

class LoadConversationsUseCase {
  final ConversationRepository _conversationRepository;

  LoadConversationsUseCase(
      {required ConversationRepository conversationRepository})
      : _conversationRepository = conversationRepository;

  Future<List<ConversationEntity>> call(String userId) async {
    return await _conversationRepository.getConversationsForUser(userId);
  }
}
