import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../widgets/conversation_item_widget.dart';

class HomePageBodyWidget extends StatelessWidget {
  const HomePageBodyWidget({
    super.key,
    required HomeController homeController,
    required this.userId,
  }) : _homeController = homeController;

  final HomeController _homeController;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _homeController.loadConversations(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading conversations'),
          );
        } else {
          return Obx(() {
            final conversations = _homeController.conversations;
            if (conversations.isEmpty) {
              return const Center(
                child: Text('Không có cuộc trò chuyện nào.'),
              );
            }
            return Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return GestureDetector(
                    onTap: () {
                      _homeController.navigateToChat(conversation);
                    },
                    child: ConversationItemWidget(
                        title: conversation.name ??
                            'Cuộc trò chuyện chưa có tiêu đề',
                        lastMessage: conversation.lastMessage ?? '',
                        lastMessageTime: conversation.lastMessageTime ?? ''),
                  );
                },
              ),
            );
          });
        }
      },
    );
  }
}
