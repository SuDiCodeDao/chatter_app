import 'package:chatter_app/core/constants/message_reaction.dart';
import 'package:chatter_app/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {super.id,
      super.content,
      super.sender,
      super.timeStamp,
      super.reaction,
      super.conversationId});

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      id: data['id'] ?? '',
      content: data['content'] ?? '',
      sender: data['sender'] ?? '',
      timeStamp: data['timeStamp'] ?? DateTime.now().toLocal().toString(),
      reaction: data['reaction'] ?? MessageReaction.none,
      conversationId: data['conversationId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timeStamp': timeStamp,
      'reaction': reaction,
      'conversationId': conversationId
    };
  }

  MessageModel.fromEntity(MessageEntity messageEntity)
      : super(
            id: messageEntity.id,
            content: messageEntity.content,
            sender: messageEntity.sender,
            timeStamp: messageEntity.timeStamp,
            reaction: messageEntity.reaction,
            conversationId: messageEntity.conversationId);

  MessageEntity toEntity() {
    return MessageEntity(
        id: id,
        content: content,
        sender: sender,
        timeStamp: timeStamp,
        reaction: reaction,
        conversationId: conversationId);
  }
}
