import 'package:chatter_app/core/constants/message_reaction.dart';

class MessageEntity {
  String? id;
  String? content;
  String? role;
  String? timeStamp;
  MessageReaction? reaction;

  MessageEntity({
    this.id,
    this.content,
    this.role,
    this.timeStamp,
    this.reaction,
  });
}
