import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/conversation_item_widget.dart';

class HomePageBodyWidget extends StatelessWidget {
  const HomePageBodyWidget({
    super.key,
    required HomeController homeController,
    required AuthController authController,
  })  : _homeController = homeController,
        _authController = authController;

  final HomeController _homeController;
  final AuthController _authController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          _homeController.loadConversations(_authController.userEntity.uid!),
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
      },
    );
  }
}
