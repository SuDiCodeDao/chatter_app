import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/message_model.dart';
import 'firebase_message_datasource.dart';

class FirebaseMessageDataSourceImpl extends FirebaseMessageDataSource {
  final FirebaseFirestore firestore;

  FirebaseMessageDataSourceImpl({required this.firestore});

  @override
  Future<MessageModel> deleteMessage(
      String conversationId, String messageId) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);
    final messageData = (await conversationRef.get()).data();
    final List<Map<String, dynamic>> messages =
        List.from(messageData?['messages']);

    final int indexToDelete =
        messages.indexWhere((message) => message['id'] == messageId);
    if (indexToDelete != -1) {
      messages.removeAt(indexToDelete);

      await conversationRef.update({'messages': messages});
    } else {
      throw Exception('Không tìm thấy tin nhắn để xóa');
    }

    return MessageModel.fromMap(messageData!);
  }

  @override
  Future<MessageModel> getMessage(
      String conversationId, String messageId) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);
    final messageData = (await conversationRef.get()).data();

    final message = messageData?['messages'].firstWhere(
        (message) => message['id'] == messageId,
        orElse: () => null);
    if (message != null) {
      return MessageModel.fromMap(message);
    } else {
      throw Exception('Không tìm thấy tin nhắn');
    }
  }

  @override
  Future<List<MessageModel>?> getMessagesInConversation(
      String conversationId) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);

    final conversationData = (await conversationRef.get()).data();
    if (conversationData != null) {
      if (conversationData['messages'] != null) {
        final List<Map<String, dynamic>> messages =
            List.from(conversationData['messages']);
        messages.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

        final messageModels =
            messages.map((message) => MessageModel.fromMap(message)).toList();

        return messageModels;
      } else {
        if (conversationData['messages'] != null) {
          final List<Map<String, dynamic>> messages =
              List.from(conversationData['messages']);
          messages.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

          final messageModels =
              messages.map((message) => MessageModel.fromMap(message)).toList();

          return messageModels;
        } else {
          return [];
        }
      }
    }
    return null;
  }

  @override
  Future<MessageModel?> getLastMessageInConversation(
      String conversationId) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);

    final messageData = (await conversationRef.get()).data();
    final List<Map<String, dynamic>> messages =
        List.from(messageData?['messages']);

    if (messages.isNotEmpty) {
      messages.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
      return MessageModel.fromMap(messages.first);
    } else {
      throw Exception('Không tìm thấy tin nhắn cuối cùng');
    }
  }

  @override
  Future<MessageModel> reactToMessage(String messageId) {
    // TODO: implement reactToMessage
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> searchMessages(
      String conversationId, String query) async {
    final conversationRef =
        firestore.collection('conversations').doc(conversationId);

    final messageData = (await conversationRef.get()).data();
    final List<Map<String, dynamic>> messages =
        List.from(messageData?['messages'] ?? []);

    final List<MessageModel> searchResults = [];

    for (final message in messages) {
      final text = message['content'].toString().toLowerCase();

      if (text.contains(query.toLowerCase())) {
        searchResults.add(MessageModel.fromMap(message));
      }
    }

    return searchResults;
  }

  @override
  Future<void> sendMessage(
      String conversationId, MessageModel messageModel) async {
    if (conversationId.isNotEmpty) {
      final collectionRef =
          firestore.collection('conversations').doc(conversationId);
      final messageData = messageModel.toMap();
      final conversationData = (await collectionRef.get()).data();
      final List<Map<String, dynamic>> messages =
          List.from(conversationData?['messages'] ?? []);
      messages.add(messageData);
      await collectionRef.update({'messages': messages});
      await collectionRef.update({
        'lastMessage': messageData['content'],
        'lastMessageTime': messageData['timeStamp']
      });
    }
  }

  @override
  Future<void> deleteAllMessagesInConversation(String conversationId) async {
    try {
      final messages = await getMessagesInConversation(conversationId);
      if (messages != null) {
        for (final message in messages) {
          await deleteMessage(conversationId, message.id!);
        }
      }
      final collectionRef =
          firestore.collection('conversations').doc(conversationId);
      await collectionRef.update({
        'lastMessage': '',
        'lastMessageTime': '',
      });
    } catch (e) {
      throw Exception('Failed to delete all messages: $e');
    }
  }
}
