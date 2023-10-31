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
  List<MessageEntity> messages = <MessageEntity>[].obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadMessages('cIKzo1Op9UTdX6IJnYMEfjiC3mt2');
  }

  ChatController(
      {required SendMessageUseCase sendMessageUseCase,
      required ReceiveChatbotResponseUseCase receiveChatbotResponseUseCase,
      required LoadMessagesUseCase loadMessagesUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _receiveChatbotResponseUseCase = receiveChatbotResponseUseCase,
        _loadMessagesUseCase = loadMessagesUseCase;

  Future<void> loadMessages(String conversationId) async {
    final loadedMessages = await _loadMessagesUseCase.call(conversationId);
    // print('Loaded messages: $loadedMessages');
    if (loadedMessages != null) {
      messages.assignAll(loadedMessages);
      refresh();
      update();
      //   messages.addAll(loadedMessages);
      //   //messages.insertAll(0, loadedMessages);
      //   //messages.addAllIf(loadedMessages != null, loadedMessages);
    } else {
      messages.assign(MessageEntity(
          content: 'Xin chao toi la chatbot', role: 'gpt', timeStamp: DateTime.now().toLocal().toString()));
      refresh();
      update();
    }
  }

  Future<void> sendUserMessage(String conversationId, String? messageContent) async {
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

  Future<void> handleChatbotResponse(String conversationId, String prompt) async {
    final chatbotTypingMessage = MessageEntity(
      id: const Uuid().v1(),
      content: 'Chatbot đang phản hồi...',
      role: 'gpt',
      timeStamp: DateTime.now().toLocal().toString(),
      reaction: MessageReaction.none,
    );
    messages.insert(0, chatbotTypingMessage);
    update();
    final message = await _receiveChatbotResponseUseCase.call(conversationId, prompt);
    messages.remove(chatbotTypingMessage);
    messages.insert(0, message!);
    refresh();
    update();
  }
}
