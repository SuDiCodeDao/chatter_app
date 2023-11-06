import 'package:chatter_app/app/presentation/controllers/chat_controller.dart';
import 'package:chatter_app/app/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/app_injection.dart';
import 'widgets/chat_area_widget.dart';
import 'widgets/chat_input_area_widget.dart';

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
            Get.back<bool?>(result: true);
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
          ChatInputAreaWidget(
              chatController: _chatController, homeController: _homeController),
        ],
      ),
    );
  }
}
