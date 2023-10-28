import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/remote/firebase/conversation/firebase_conversation_datasource.dart';
import '../datasources/remote/firebase/message/firebase_message_datasource.dart';
import '../models/conversation_model.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  final FirebaseConversationDataSource firebaseConversationDataSource;
  final FirebaseMessageDataSource firebaseMessageDataSource;

  ConversationRepositoryImpl(
      {required this.firebaseConversationDataSource,
      required this.firebaseMessageDataSource});

  @override
  Future<List<ConversationEntity>> getConversationsForUser(
      String userId) async {
    try {
      final conversations =
          await firebaseConversationDataSource.getConversationsForUser(userId);
      if (conversations.isEmpty) {
        throw Exception('Không tìm thấy cuộc trò chuyện');
      }
      for (final conversation in conversations) {
        final lastMessage = await firebaseMessageDataSource
            .getLastMessageInConversation(conversation!.id!);
        conversation.lastMessage = lastMessage?.content ?? 'Không có tin nhắn';
        conversation.lastMessageTime = lastMessage?.timeStamp ?? '';
      }
      return conversations.map((conversationModel) {
        return conversationModel!.toEntity();
      }).toList();
    } catch (e) {
      print('Lỗi: $e');

      return [];
    }
  }

  @override
  Future<void> createConversation(ConversationEntity conversationEntity) async {
    var conversationModel = ConversationModel.fromEntity(conversationEntity);
    await firebaseConversationDataSource.addConversation(conversationModel);
  }
}
