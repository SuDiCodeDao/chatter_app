import 'package:chatter_app/app/domain/repositories/gpt_repository.dart';

import '../../entities/message_entity.dart';

class GetGptResponseUseCase {
  final GptRepository _gptRepository;

  GetGptResponseUseCase({required GptRepository gptRepository})
      : _gptRepository = gptRepository;

  Future<MessageEntity?> call(String prompt) async {
    return await _gptRepository.getGptResponse(prompt);
  }
}
