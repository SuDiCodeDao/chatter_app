import 'package:flutter/material.dart';

import '../../../controllers/home_controller.dart';
import 'conversations_list_widget.dart';

class HomePageBodyWidget extends StatelessWidget {
  const HomePageBodyWidget({
    super.key,
    required this.userId,
    required this.homeController,
  });

  final HomeController homeController;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homeController.loadConversations(userId),
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
          return ConversationsListWidget(
              homeController: homeController, userId: userId);
        }
      },
    );
  }
}
