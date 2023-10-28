import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/message_model.dart';
import 'firebase_message_datasource.dart';

class FirebaseMessageDataSourceImpl extends FirebaseMessageDataSource {
  final FirebaseFirestore firestore;

  FirebaseMessageDataSourceImpl({required this.firestore});
  @override
  Future<MessageModel> deleteMessage(String messageId) async {
    final docRef = firestore.collection('messages').doc(messageId);
    final deletedMessage = await docRef.get();
    await docRef.delete();
    return MessageModel.fromMap(deletedMessage.data()!);
  }

  @override
  Future<MessageModel> getMessage(String messageId) async {
    final docRef = firestore.collection('messages').doc(messageId);
    final message = await docRef.get();
    return MessageModel.fromMap(message.data()!);
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    final querySnapshot = await firestore.collection('messages').get();
    final messages = querySnapshot.docs
        .map((doc) => MessageModel.fromMap(doc.data()))
        .toList();
    return messages;
  }

  @override
  Future<List<MessageModel>?> getMessagesInConversation(
      String conversationId) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);

    final conversation = await conversationRef.get();
    if (!conversation.exists) {
      return null; //
    }

    final querySnapshot = await conversationRef
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .get();

    final messages = querySnapshot.docs
        .map((doc) => MessageModel.fromMap(doc.data()))
        .toList();

    return messages;
  }

  @override
  Future<MessageModel?> getLastMessageInConversation(
      String conversationId) async {
    try {
      final querySnapshot = await firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .limit(1)
          .orderBy('timeStamp', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final lastMessage =
            MessageModel.fromMap(querySnapshot.docs.first.data());
        return lastMessage;
      } else {
        throw Exception('Không tìm thấy tin nhắn cuối cùng');
      }
    } catch (e) {
      print('Lỗi: $e');
      return null;
    }
  }

  @override
  Future<int> getUnreadMessagesCount(String conversationId) {
    // TODO: implement getUnreadMessagesCount
    throw UnimplementedError();
  }

  @override
  Future<MessageModel> reactToMessage(String messageId, String reactionType) {
    // TODO: implement reactToMessage
    throw UnimplementedError();
  }

  @override
  Future<MessageModel> searchMessages(String query) {
    // TODO: implement searchMessages
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(MessageModel messageModel) async {
    final collectionRef = firestore.collection('messages');
    await collectionRef.doc(messageModel.id).set(messageModel.toMap());
  }
}
