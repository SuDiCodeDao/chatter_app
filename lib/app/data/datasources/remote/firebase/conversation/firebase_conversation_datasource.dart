import '../../../../models/conversation_model.dart';

abstract class FirebaseConversationDataSource {
  Future<List<ConversationModel?>> getConversationsForUser(String userId);
  Future<ConversationModel?> getConversation(String conversationId);
  Future<void> addConversation(ConversationModel conversationModel);
  Future<ConversationModel?> deleteConversation(String conversationId);
}
