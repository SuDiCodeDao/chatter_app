import 'package:flutter/material.dart';

import '../../../core/constants/function_constants.dart';

class ConversationItemWidget extends StatelessWidget {
  final String title;
  final String lastMessage;
  final String lastMessageTime;

  const ConversationItemWidget({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = formatLastMessageTime(lastMessageTime);
    return Card(
      borderOnForeground: true,
      margin: const EdgeInsets.all(10.0),
      elevation: 4,
      color: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Đặt bo góc
      ),
      child: ListTile(
        title: Text(
          title,
        ),
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                lastMessage,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            Text(formattedTime)
          ],
        ),
      ),
    );
  }
}
