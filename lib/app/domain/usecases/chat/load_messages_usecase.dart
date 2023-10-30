import '../../entities/message_entity.dart';
import '../../repositories/message_repository.dart';

class LoadMessagesUseCase {
  final MessageRepository _messageRepository;

  LoadMessagesUseCase({required MessageRepository messageRepository})
      : _messageRepository = messageRepository;

  Future<List<MessageEntity>?> call(String conversationId) async {
    return await _messageRepository.getMessagesInConversation(conversationId);
  }
}
