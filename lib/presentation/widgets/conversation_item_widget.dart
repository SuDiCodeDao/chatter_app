import 'package:flutter/material.dart';

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
    final now = DateTime.now();
    final lastMessageTimeDateTime = DateTime.parse(lastMessageTime);

    String formattedTime;
    if (lastMessageTimeDateTime.year != now.year ||
        lastMessageTimeDateTime.month != now.month ||
        lastMessageTimeDateTime.day != now.day) {
      formattedTime =
          '${lastMessageTimeDateTime.day}/${lastMessageTimeDateTime.month}/${lastMessageTimeDateTime.year} ${lastMessageTimeDateTime.hour}:${lastMessageTimeDateTime.minute}';
    } else {
      formattedTime =
          '${lastMessageTimeDateTime.hour}:${lastMessageTimeDateTime.minute}';
    }

    return ListTile(
      title: Text(title),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text(lastMessage), Text(formattedTime)],
      ),
    );
  }
}
