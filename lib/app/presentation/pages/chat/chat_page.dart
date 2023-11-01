import 'package:chatter_app/app/presentation/controllers/chat_controller.dart';
import 'package:chatter_app/app/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/di/app_injection.dart';
import 'widgets/chat_area_widget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatController _chatController = locator<ChatController>();
  final HomeController _homeController = locator<HomeController>();

  @override
  Widget build(BuildContext context) {
    final messages = _chatController.messages;

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        centerTitle: true,
        title: Text(_homeController
            .selectConversation(_homeController.selectedConversationId.value)
            .name!),
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatAreaWidget(
                chatController: _chatController,
                homeController: _homeController,
                messages: messages),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
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
                IconButton(
                  icon: _chatController.isListening
                      ? const Icon(Icons.stop, color: Colors.lightBlueAccent)
                      : const Icon(Icons.keyboard_voice,
                          color: Colors.lightBlueAccent),
                  onPressed: () {
                    _chatController.isListening
                        ? _chatController.stopListening()
                        : _chatController.startListening(
                            _homeController.selectedConversationId.value);
                  },
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
          ),
        ],
      ),
    );
  }
}
