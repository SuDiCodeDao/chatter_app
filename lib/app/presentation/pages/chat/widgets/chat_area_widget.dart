import 'package:flutter/material.dart';
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
    // return Obx(
    //   () => Expanded(
    //     child: _chatController.messages.isEmpty
    //         ? const Center(
    //             child: Text('message is empty'),
    //           )
    //         : ListView.builder(
    //             reverse: true,
    //             physics: const ClampingScrollPhysics(),
    //             itemCount: _chatController.messages.length,
    //             itemBuilder: (context, index) {
    //               final message = _chatController.messages[index];
    //               final isUserMessage = message.role == 'user';
    //               return buildMessageBubble(message, isUserMessage, context);
    //             },
    //           ),
    //   ),
    // );
    return FutureBuilder(
      future: _chatController
          .loadMessages(_homeController.selectedConversationId.value),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (messages.isEmpty) {
          return const Center(
            child: Text('Không có tin nhắn nào.'),
          );
        }
        return Obx(
          () => Expanded(
            child: ListView.builder(
              reverse: true,
              physics: const ClampingScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message.role == 'user';
                return buildMessageBubble(message, isUserMessage, context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildMessageBubble(
      MessageEntity message, bool isUserMessage, BuildContext context) {
    return Container(
      margin: isUserMessage
          ? const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8)
          : const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.lightBlueAccent : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2 / 3,
            ),
            child:
                message.content != null && message.content!.startsWith('http')
                    ? Image.network(message.content!)
                    : Text(
                        message.content!,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
