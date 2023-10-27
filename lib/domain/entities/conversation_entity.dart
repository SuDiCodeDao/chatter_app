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
}
