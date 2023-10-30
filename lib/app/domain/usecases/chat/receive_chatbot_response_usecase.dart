import 'package:chatter_app/app/domain/repositories/gpt_repository.dart';

import '../../entities/message_entity.dart';

class ReceiveChatbotResponseUseCase {
  final GptRepository _gptRepository;

  ReceiveChatbotResponseUseCase({required GptRepository gptRepository})
      : _gptRepository = gptRepository;

  Future<MessageEntity?> call(String conversationId, String prompt) async {
    return _gptRepository.getGptResponse(conversationId, prompt);
  }
}
