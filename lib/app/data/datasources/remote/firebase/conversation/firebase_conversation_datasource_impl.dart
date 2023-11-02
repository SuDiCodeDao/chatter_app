import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/conversation_model.dart';
import 'firebase_conversation_datasource.dart';

class FirebaseConversationDataSourceImpl
    extends FirebaseConversationDataSource {
  final FirebaseFirestore firestore;

  FirebaseConversationDataSourceImpl({required this.firestore});

  @override
  Future<void> addConversation(ConversationModel conversationModel) async {
    final docRef = firestore.collection('conversations');
    await docRef.doc(conversationModel.id).set(conversationModel.toMap());
  }

  @override
  Future<ConversationModel?> deleteConversation(String conversationId) async {
    final docRef = firestore.collection('conversations').doc(conversationId);
    final conversationData = await docRef.get();

    if (conversationData.exists) {
      await docRef.delete();
      return ConversationModel.fromMap(conversationData.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<ConversationModel?> getConversation(String conversationId) async {
    final docRef = firestore.collection('conversations').doc(conversationId);
    final conversation = await docRef.get();
    if (!conversation.exists) {
      throw Exception('Không tìm thấy cuộc trò chuyện');
    }
    return ConversationModel.fromMap(conversation.data()!);
  }

  @override
  Future<List<ConversationModel?>> getConversationsForUser(
      String userId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('userId', isEqualTo: userId)
        .get();

    final conversations = querySnapshot.docs
        .map((doc) => ConversationModel.fromMap(doc.data()))
        .toList();
    if (conversations.isEmpty) {
      return [];
    }
    return conversations;
  }
}
