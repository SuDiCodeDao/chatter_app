import 'package:chatter_app/data/datasources/remote/firebase/conversation/firebase_conversation_datasource.dart';
import 'package:chatter_app/data/datasources/remote/firebase/message/firebase_message_datasource.dart';
import 'package:chatter_app/domain/entities/conversation_entity.dart';
import 'package:chatter_app/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  final FirebaseConversationDataSource firebaseConversationDataSource;
  final FirebaseMessageDataSource firebaseMessageDataSource;

  ConversationRepositoryImpl(
      {required this.firebaseConversationDataSource,
      required this.firebaseMessageDataSource});

  @override
  Future<List<ConversationEntity>> getConversationsForUser(
      String userId) async {
    final conversations =
        await firebaseConversationDataSource.getConversationsForUser(userId);
    for (final conversation in conversations) {
      final lastMessage = await firebaseMessageDataSource
          .getLastMessageInConversation(conversation!.id!);

      conversation.lastMessage = lastMessage?.content ?? '';
      conversation.lastMessageTime = lastMessage?.timeStamp ?? '';
    }
    return conversations.map((conversationModel) {
      return conversationModel!.toEntity();
    }).toList();
  }
}
