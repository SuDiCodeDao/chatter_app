import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>?> getMessagesInConversation(String conversationId);

  Future<void> sendMessage(String conversationId, MessageEntity messageEntity);

  Future<void> deleteAllMessagesInConversation(String conversationId);
}
