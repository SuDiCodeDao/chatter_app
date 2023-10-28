import '../../../../models/message_model.dart';

abstract class FirebaseMessageDataSource {
  Future<List<MessageModel>?> getMessagesInConversation(String conversationId);

  Future<MessageModel> getMessage(String messageId);

  Future<MessageModel> deleteMessage(String messageId);
  Future<MessageModel?> getLastMessageInConversation(String conversationId);
  Future<List<MessageModel>> getMessages();

  Future<void> sendMessage(MessageModel messageModel);

  Future<int> getUnreadMessagesCount(String conversationId);

  Future<MessageModel> searchMessages(String query);

  Future<MessageModel> reactToMessage(String messageId, String reactionType);
}
