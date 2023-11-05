import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/function_constants.dart';
import '../../../controllers/home_controller.dart';

class ConversationsListWidget extends StatelessWidget {
  const ConversationsListWidget({
    super.key,
    required this.homeController,
    required this.userId,
  });

  final HomeController homeController;
  final String userId;

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
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return GestureDetector(
            onTap: () {
              homeController.navigateToChat(conversation, userId);
            },
            child: Card(
              borderOnForeground: true,
              margin: EdgeInsets.all(10.0.w),
              elevation: 4.w,
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0.w), // Đặt bo góc
              ),
              child: ListTile(
                title: Text(
                  conversation.name ?? 'Cuộc trò chuyện chưa có tiêu đề',
                ),
                trailing: IconButton(
                  onPressed: () async {
                    if (!homeController.isDeletingConversation.value) {
                      homeController.isDeletingConversation.value = true;
                      await homeController.deleteConversation(
                        userId,
                        conversation.id!,
                      );
                      homeController.isDeletingConversation.value = false;
                    }
                  },
                  icon: Stack(
                    children: [
                      if (homeController.isDeletingConversation.value)
                        const Positioned.fill(
                          child: CircularProgressIndicator(),
                        ),
                      const Icon(Icons.delete),
                    ],
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        conversation.lastMessage ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                    Text(
                      formatLastMessageTime(conversation.lastMessageTime ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
