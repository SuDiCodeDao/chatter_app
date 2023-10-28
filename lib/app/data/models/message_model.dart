import '../../../core/constants/message_reaction.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    super.id,
    super.content,
    super.role,
    super.timeStamp,
    super.reaction,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      id: data['id'] ?? '',
      content: data['content'] ?? '',
      role: data['role'] ?? '',
      timeStamp: data['timeStamp'] ?? DateTime.now().toLocal().toString(),
      reaction: _parseReaction(data['reaction']),
    );
  }
  static MessageReaction _parseReaction(String? reaction) {
    if (reaction == 'like') {
      return MessageReaction.like;
    } else if (reaction == 'dislike') {
      return MessageReaction.dislike;
    } else {
      return MessageReaction.none;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'role': role,
      'timeStamp': timeStamp,
      'reaction': reaction.toString().split('.').last,
    };
  }

  MessageModel.fromEntity(MessageEntity messageEntity)
      : super(
          id: messageEntity.id,
          content: messageEntity.content,
          role: messageEntity.role,
          timeStamp: messageEntity.timeStamp,
          reaction: messageEntity.reaction,
        );

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      role: role,
      timeStamp: timeStamp,
      reaction: reaction,
    );
  }
}
