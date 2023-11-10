import 'package:chatter_app/app/domain/usecases/chat/clear_all_message_usecase.dart';
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

  final isListening = false.obs;

  final ReceiveChatbotResponseUseCase _receiveChatbotResponseUseCase;
  final LoadMessagesUseCase _loadMessagesUseCase;
  final ClearAllMessageUseCase _clearAllMessageUseCase;
  RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final TextEditingController messageController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  RxBool isSpeechAvailable = false.obs;
  ChatController(
      {required SendMessageUseCase sendMessageUseCase,
      required ReceiveChatbotResponseUseCase receiveChatbotResponseUseCase,
      required LoadMessagesUseCase loadMessagesUseCase,
      required ClearAllMessageUseCase clearAllMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _receiveChatbotResponseUseCase = receiveChatbotResponseUseCase,
        _clearAllMessageUseCase = clearAllMessageUseCase,
        _loadMessagesUseCase = loadMessagesUseCase;

  @override
  void onReady() {
    super.onInit();
    print('onInit called');
    _initSpeech();
  }

  Future<void> loadMessages(String conversationId) async {
    debugPrint('call loadMessages $conversationId');
    final loadedMessages = await _loadMessagesUseCase.call(conversationId);

    if ((loadedMessages ?? []).isNotEmpty) {
      messages.clear();
      update();
      refresh();
      messages.assignAll(loadedMessages ?? []);
      refresh();
      update();
    } else {
      messages.clear();
      update();
      refresh();
      messages.insert(
          0,
          MessageEntity(
              content:
                  'Xin chào, tôi là AI siu thông minh. Rất vui được giúp bạn... :))',
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
      messages.insert(0, messageEntity);
      await handleChatbotResponse(conversationId, messageContent);
      refresh();
      update();
    }
  }

  Future<void> clearAllMessagesInConversation(String conversationId) async {
    try {
      await _clearAllMessageUseCase(conversationId);
      messages.clear();
      update();
      refresh();
    } catch (e) {}
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
    if (isListening.value) {
      await _speechToText.stop();
      isListening.value = false;
      update();
    }
  }

  Future<void> startListening(String conversationId) async {
    isListening.value = true;
    if (await _initSpeech()) {
      await _speechToText.listen(
          onResult: (result) => _onSpeechResult(conversationId, result),
          cancelOnError: true,
          listenFor: const Duration(seconds: 10));
      update();
    } else {
      print('Speech to text not available');
    }
  }

  Future<bool> _initSpeech() async {
    isSpeechAvailable.value = await _speechToText.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == 'notListening') {
          isListening.value = false;
          update();
        }
      },
      onError: (error) {
        print('Error: ${error.errorMsg}');
        isListening.value = false;
        _speechToText.stop();
        update();
      },
    );
    print('isSpeechAvailable: ${isSpeechAvailable.value}');
    return isSpeechAvailable.value;
  }

  Future<void> _onSpeechResult(
      String conversationId, SpeechRecognitionResult result) async {
    try {
      if (_speechToText.isAvailable && _speechToText.isListening) {
        if (result.recognizedWords.isNotEmpty) {
          var messageEntity = MessageEntity(
            id: const Uuid().v1(),
            content: result.recognizedWords,
            role: 'user',
            timeStamp: DateTime.now().toLocal().toString(),
            reaction: MessageReaction.none,
          );
          await _sendMessageUseCase.call(conversationId, messageEntity);
          messages.insert(0, messageEntity);
          handleChatbotResponse(conversationId, result.recognizedWords);
          refresh();
          update();
        }
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }
}
