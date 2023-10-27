import 'package:chatter_app/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> getConversationsForUser(String userId);
}
