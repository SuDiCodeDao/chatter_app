import 'dart:math';

class ConversationEntity {
  String? id;
  String? name;
  String? userId;

  String? lastMessage;
  String? lastMessageTime;

  ConversationEntity({
    this.id,
    this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.userId,
  });

  ConversationEntity.generateRandomId(String userId) {
    final random = Random();
    id = random.nextInt(1000000).toString();
    name = 'Cuộc trò chuyện không có tiêu đề';
    userId = userId;
  }
}
