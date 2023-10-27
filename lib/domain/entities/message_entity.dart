class MessageEntity {
  String? id;
  String? content;
  String? sender;
  String? timeStamp;
  String? reaction;
  String? conversationId;

  MessageEntity(
      {this.id,
      this.content,
      this.sender,
      this.timeStamp,
      this.reaction,
      this.conversationId});
}
