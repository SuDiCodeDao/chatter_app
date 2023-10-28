import '../../domain/entities/conversation_entity.dart';
import 'message_model.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    super.id,
    super.name,
    super.userId,
    super.messages,
    super.lastMessage,
    super.lastMessageTime,
    super.createAt,
  });
  factory ConversationModel.fromMap(Map<String, dynamic> data) {
    return ConversationModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
      messages: (data['messages'] as List<dynamic>?)
          ?.map((messageData) => MessageModel.fromMap(messageData))
          .toList(),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] ?? '',
      createAt: data['createAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'messages': messages
          ?.map((message) => MessageModel.fromEntity(message).toMap())
          .toList(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createAt': createAt,
    };
  }

  ConversationModel.fromEntity(ConversationEntity conversationEntity)
      : super(
            id: conversationEntity.id,
            name: conversationEntity.name,
            userId: conversationEntity.userId,
            messages: conversationEntity.messages,
            lastMessage: conversationEntity.lastMessage,
            lastMessageTime: conversationEntity.lastMessageTime,
            createAt: conversationEntity.createAt);

  ConversationEntity toEntity() {
    return ConversationEntity(
        id: id,
        name: name,
        userId: userId,
        messages: messages,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        createAt: createAt);
  }
}
