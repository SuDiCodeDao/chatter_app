import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/message_entity.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/home_controller.dart';

class ChatAreaWidget extends StatelessWidget {
  const ChatAreaWidget({
    super.key,
    required ChatController chatController,
    required HomeController homeController,
    required this.messages,
  })  : _chatController = chatController,
        _homeController = homeController;

  final ChatController _chatController;
  final HomeController _homeController;
  final RxList<MessageEntity> messages;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _chatController
          .loadMessages(_homeController.selectedConversationId.value),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitCubeGrid(
              color: Colors.lightBlueAccent,
              size: 50.0,
            ),
          );
        }

        if (messages.isEmpty) {
          return const Center(
            child: Text('Không có tin nhắn nào.'),
          );
        }
        return Obx(
          () => ListView.builder(
            reverse: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _chatController.messages.length,
            itemBuilder: (context, index) {
              final message = _chatController.messages[index];
              final isUserMessage = message.role == 'user';
              return buildMessageBubble(message, isUserMessage, context);
            },
          ),
        );
      },
    );
  }

  Widget buildMessageBubble(
      MessageEntity message, bool isUserMessage, BuildContext context) {
    return Container(
      margin: isUserMessage
          ? EdgeInsets.only(left: 16.w, top: 8.h, right: 16.w, bottom: 8.h)
          : EdgeInsets.only(left: 16.w, top: 8.h, right: 16.w, bottom: 8.h),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.lightBlueAccent : Colors.grey,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1.w,
                  blurRadius: 3.w,
                  offset: Offset(0.w, 2.h),
                )
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: 262.w,
            ),
            child:
                message.content != null && message.content!.startsWith('http')
                    ? Image.network(message.content!)
                    : Text(
                        message.content!,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
