import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/chat_controller.dart';
import '../../../controllers/home_controller.dart';

class ChatInputAreaWidget extends StatelessWidget {
  const ChatInputAreaWidget({
    super.key,
    required ChatController chatController,
    required HomeController homeController,
  })  : _chatController = chatController,
        _homeController = homeController;

  final ChatController _chatController;
  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                _chatController.clearAllMessagesInConversation(
                    _homeController.selectedConversationId.value);
              },
              icon: const Icon(
                Icons.clear_all,
                color: Colors.lightBlueAccent,
              )),
          Expanded(
            child: TextField(
              controller: _chatController.messageController,
              onSubmitted: (text) =>
                  _chatController.messageController.text = text,
              maxLines: null,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                _chatController.isListening.value ? Icons.pause : Icons.mic,
                color: Colors.lightBlueAccent,
              ),
              onPressed: () {
                _chatController.isListening.value
                    ? _chatController.stopListening()
                    : _chatController.startListening(
                        _homeController.selectedConversationId.value);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              final messageContent =
                  _chatController.messageController.text.trim();
              if (messageContent.isNotEmpty) {
                _chatController.sendUserMessage(
                    _homeController.selectedConversationId.value,
                    messageContent);
                _chatController.messageController.text = '';
              }
            },
            icon: const Icon(
              Icons.send,
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
