import 'message_entity.dart';

class ConversationEntity {
  String? id;
  String? name;
  String? userId;
  String? createAt;
  List<MessageEntity>? messages;
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
