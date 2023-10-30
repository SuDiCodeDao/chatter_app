import 'package:chatter_app/app/data/models/message_model.dart';

import '../entities/message_entity.dart';

abstract class GptRepository {
  Future<MessageEntity?> getGptResponse(String conversationId, String prompt);
  Future<void> saveBotResponse(
      String conversationId, MessageModel messageModel);
}
