import 'package:chatter_app/app/domain/repositories/conversation_repository.dart';

class DeleteConversationUseCase {
  final ConversationRepository _conversationRepository;

  DeleteConversationUseCase(
      {required ConversationRepository conversationRepository})
      : _conversationRepository = conversationRepository;

  Future<void> call(String conversationId) async {
    await _conversationRepository.deleteConversation(conversationId);
  }
}
