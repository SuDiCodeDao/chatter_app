import 'package:chatter_app/presentation/controllers/home_controller.dart';
import 'package:chatter_app/presentation/widgets/conversation_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageBodyWidget extends StatelessWidget {
  HomePageBodyWidget({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conversations = homeController.conversations;
      if (conversations.isEmpty) {
        return const Center(
          child: Text('Không có cuộc trò chuyện nào.'),
        );
      }
      return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ConversationItemWidget(
              title: conversation.name ?? '',
              lastMessage: conversation.lastMessage ?? '',
              lastMessageTime: conversation.lastMessageTime ?? '');
        },
      );
    });
  }
}
