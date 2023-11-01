import 'package:chatter_app/app/domain/usecases/chat/load_messages_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/receive_chatbot_response_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/send_message_usecase.dart';
import 'package:chatter_app/core/constants/message_reaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message_entity.dart';

class ChatController extends GetxController {
  final SendMessageUseCase _sendMessageUseCase;

  final ReceiveChatbotResponseUseCase _receiveChatbotResponseUseCase;
  final LoadMessagesUseCase _loadMessagesUseCase;
  RxList<MessageEntity> messages = <MessageEntity>[].obs;
  var isListening = false.obs;
  final TextEditingController messageController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  final RxString lastWords = ''.obs;
  ChatController(
      {required SendMessageUseCase sendMessageUseCase,
      required ReceiveChatbotResponseUseCase receiveChatbotResponseUseCase,
      required LoadMessagesUseCase loadMessagesUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _receiveChatbotResponseUseCase = receiveChatbotResponseUseCase,
        _loadMessagesUseCase = loadMessagesUseCase;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> loadMessages(String conversationId) async {
    final loadedMessages = await _loadMessagesUseCase.call(conversationId);

    if (loadedMessages != null) {
      messages.assignAll(loadedMessages);

      refresh();
      update();
    } else {
      messages.insert(
          0,
          MessageEntity(
              content: 'Xin chao toi la chatbot',
              role: 'gpt',
              timeStamp: DateTime.now().toLocal().toString()));
      refresh();
      update();
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
    final chatbotTypingMessage = MessageEntity(
      id: const Uuid().v1(),
      content: 'Chatbot đang phản hồi...',
      role: 'gpt',
      timeStamp: DateTime.now().toLocal().toString(),
      reaction: MessageReaction.none,
    );
    messages.insert(0, chatbotTypingMessage);
    update();
    final message =
        await _receiveChatbotResponseUseCase.call(conversationId, prompt);
    messages.remove(chatbotTypingMessage);
    messages.insert(0, message!);
    refresh();
    update();
  }

  void stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
  }

  Future<void> startListening(String conversationId) async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  Future<void> _initSpeech() async {
    isListening.value = await _speechToText.initialize();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords.value = result.recognizedWords;
    print(lastWords);
  }
}
