import 'package:chatter_app/app/domain/usecases/chat/load_messages_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/receive_chatbot_response_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/send_message_usecase.dart';
import 'package:chatter_app/core/constants/message_reaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message_entity.dart';

class ChatController extends GetxController {
  final SendMessageUseCase _sendMessageUseCase;
  final ReceiveChatbotResponseUseCase _receiveChatbotResponseUseCase;
  final LoadMessagesUseCase _loadMessagesUseCase;
  RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final TextEditingController messageController = TextEditingController();

  ChatController(
      {required SendMessageUseCase sendMessageUseCase,
      required ReceiveChatbotResponseUseCase receiveChatbotResponseUseCase,
      required LoadMessagesUseCase loadMessagesUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _receiveChatbotResponseUseCase = receiveChatbotResponseUseCase,
        _loadMessagesUseCase = loadMessagesUseCase;

  Future<bool> loadMessages(String conversationId) async {
    final loadedMessages = await _loadMessagesUseCase.call(conversationId);
    if (loadedMessages != null) {
      messages.assignAll(loadedMessages);
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendUserMessage(
      String conversationId, String? messageContent) async {
    if (messageContent != null) {
      var messageId = const Uuid().v1();
      final messageEntity = MessageEntity(
          id: messageId,
          content: messageContent,
          role: 'user',
          timeStamp: DateTime.now().toLocal().toString(),
          reaction: MessageReaction.none);
      await _sendMessageUseCase.call(conversationId, messageEntity);
      messages.add(messageEntity);

      await handleChatbotResponse(conversationId, messageContent);
      update();
    }
  }

  Future<void> handleChatbotResponse(
      String conversationId, String prompt) async {
    final message =
        await _receiveChatbotResponseUseCase.call(conversationId, prompt);
    messages.insert(0, message!);
    refresh();
    update();
  }
}
