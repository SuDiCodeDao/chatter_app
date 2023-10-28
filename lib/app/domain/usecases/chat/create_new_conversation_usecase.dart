import 'package:chatter_app/app/domain/entities/conversation_entity.dart';
import 'package:chatter_app/app/domain/repositories/conversation_repository.dart';

class CreateNewConversationUseCase {
  final ConversationRepository _conversationRepository;

  CreateNewConversationUseCase(
      {required ConversationRepository conversationRepository})
      : _conversationRepository = conversationRepository;

  Future<void> call(ConversationEntity conversationEntity) {
    return _conversationRepository.createConversation(conversationEntity);
  }
}
