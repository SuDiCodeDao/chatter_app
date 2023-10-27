import 'package:chatter_app/data/datasources/remote/firebase/conversation/firebase_conversation_datasource.dart';
import 'package:chatter_app/data/models/conversation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConversationDataSourceImpl
    extends FirebaseConversationDataSource {
  final FirebaseFirestore firestore;

  FirebaseConversationDataSourceImpl({required this.firestore});
  @override
  Future<void> addConversation(ConversationModel conversationModel) async {
    final docRef = firestore.collection('conversations');
    final newConversation = await docRef.add(conversationModel.toMap());
    conversationModel.id = newConversation.id;
  }

  @override
  Future<ConversationModel?> deleteConversation(String conversationId) async {
    final docRef = firestore.collection('conversations').doc(conversationId);
    final deletedMessage = await docRef.get();
    await docRef.delete();
    return ConversationModel.fromMap(deletedMessage.data()!);
  }

  @override
  Future<ConversationModel?> getConversation(String conversationId) async {
    final docRef = firestore.collection('conversations').doc(conversationId);
    final conversation = await docRef.get();
    return ConversationModel.fromMap(conversation.data()!);
  }

  @override
  Future<List<ConversationModel?>> getConversationsForUser(
      String userId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('userId', isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .get();

    final conversations = querySnapshot.docs
        .map((doc) => ConversationModel.fromMap(doc.data()))
        .toList();

    return conversations;
  }
}
