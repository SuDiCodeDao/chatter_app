import '../entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> getConversationsForUser(String userId);
  Future<void> createConversation(ConversationEntity conversationEntity);

  Future<void> deleteConversation(String conversationId);
}
