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
  final RxString _lastWords = ''.obs;
  final _speechEnable = false.obs;

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
  void onInit() {
    super.onInit();
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
    await _speechToText.stop();
    isListening.value = false;
  }

  Future<void> startListening(String conversationId) async {
    if (_speechEnable.value) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        cancelOnError: (error) {
          print('Lỗi khi lắng nghe giọng nói: $error'); // In ra thông báo lỗi
        },
      );
      isListening.value = true;
    } else {
      await _initSpeech();
      if (_speechEnable.value) {
        await _speechToText.listen(
          onResult: _onSpeechResult,
        );
        isListening.value = true;
      } else {
        isListening.value = false;
      }
    }
  }

  Future<void> _initSpeech() async {
    _speechEnable.value = await _speechToText.initialize();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (_speechEnable.value) {
      try {
        _lastWords.value = result.recognizedWords;
      } catch (e) {
        print('Lỗi: $e');
      }
    }
  }

  bool get isSpeechEnabled => _speechEnable.value;

  String get lastWords => _lastWords.value;
}
