import '../entities/message_entity.dart';

abstract class GptRepository {
  Future<MessageEntity?> getGptResponse(String prompt);
}
