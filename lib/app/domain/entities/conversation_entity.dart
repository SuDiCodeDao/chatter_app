import 'package:chatter_app/app/domain/entities/message_entity.dart';

class ConversationEntity {
  String? id;
  String? name;
  String? userId;
  List<MessageEntity>? messages;
  String? createAt;
  String? lastMessage;
  String? lastMessageTime;

  ConversationEntity(
      {this.id,
      this.name,
      this.userId,
      this.messages,
      this.lastMessage,
      this.lastMessageTime,
      this.createAt});
}
