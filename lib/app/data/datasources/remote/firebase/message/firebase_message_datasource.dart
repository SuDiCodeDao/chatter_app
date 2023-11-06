import '../../../../models/message_model.dart';

abstract class FirebaseMessageDataSource {
  Future<List<MessageModel>?> getMessagesInConversation(String conversationId);

  Future<MessageModel> getMessage(String conversationId, String messageId);

  Future<MessageModel> deleteMessage(String conversationId, String messageId);
  Future<MessageModel?> getLastMessageInConversation(String conversationId);

  Future<void> sendMessage(String conversationId, MessageModel messageModel);

  Future<List<MessageModel>> searchMessages(
      String conversationId, String query);

  Future<void> deleteAllMessagesInConversation(String conversationId);

  Future<MessageModel> reactToMessage(String messageId);
}
