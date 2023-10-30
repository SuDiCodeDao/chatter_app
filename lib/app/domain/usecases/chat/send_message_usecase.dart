import 'package:chatter_app/app/domain/entities/message_entity.dart';
import 'package:chatter_app/app/domain/repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository _messageRepository;

  SendMessageUseCase({required MessageRepository messageRepository})
      : _messageRepository = messageRepository;

  Future<void> call(String conversationId, MessageEntity messageEntity) async {
    await _messageRepository.sendMessage(conversationId, messageEntity);
  }
}
