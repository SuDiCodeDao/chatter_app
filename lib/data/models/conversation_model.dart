import 'package:chatter_app/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    super.id,
    super.name,
    super.lastMessage,
    super.lastMessageTime,
    super.userId,
  });
  factory ConversationModel.fromMap(Map<String, dynamic> data) {
    return ConversationModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'userId': userId,
    };
  }

  ConversationModel.fromEntity(ConversationEntity conversationEntity)
      : super(
          id: conversationEntity.id,
          name: conversationEntity.name,
          lastMessage: conversationEntity.lastMessage,
          lastMessageTime: conversationEntity.lastMessageTime,
          userId: conversationEntity.userId,
        );

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      name: name,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      userId: userId,
    );
  }
}
