import 'package:chatter_app/app/domain/repositories/message_repository.dart';

class ClearAllMessageUseCase {
  final MessageRepository _messageRepository;

  ClearAllMessageUseCase({required MessageRepository messageRepository})
      : _messageRepository = messageRepository;

  Future<void> call(String conversationId) async {
    await _messageRepository.deleteAllMessagesInConversation(conversationId);
  }
}
