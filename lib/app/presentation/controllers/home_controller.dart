import 'package:chatter_app/app/domain/usecases/auth/sign_out_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/create_new_conversation_usecase.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/update_user_profile_usecase.dart';
import '../../domain/usecases/chat/load_conversations_usecase.dart';

class HomeController extends GetxController {
  final isDarkMode = false.obs;
  RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  CreateNewConversationUseCase? _createNewConversationUseCase;
  SignOutUseCase? _signOutUseCase;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  LoadConversationsUseCase? _loadConversationsUseCase;
  GetCurrentUserUseCase? _getCurrentUserUseCase;

  UpdateUserUseCase? _updateUserUseCase;
  final RxString selectedConversationId = "".obs;
  HomeController(
      {loadConversationUseCase,
      signOutUseCase,
      createNewConversationUseCase,
      getCurrentUserUseCase,
      updateUserUseCase}) {
    _loadConversationsUseCase = loadConversationUseCase;
    _createNewConversationUseCase = createNewConversationUseCase;
    _getCurrentUserUseCase = getCurrentUserUseCase;
    _updateUserUseCase = updateUserUseCase;
    _signOutUseCase = signOutUseCase;
  }

  Future<void> signOut() async {
    await _signOutUseCase?.call();
    Get.offAllNamed(PageRouteConstants.login);
  }

  void toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;

    final SharedPreferences pref = await _pref;

    pref.setBool('darkMode', isDarkMode.value);

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ConversationEntity selectConversation(String conversationId) {
    selectedConversationId.value = conversationId;

    final selectedConversation = conversations.firstWhere(
      (conversation) => conversation.id == conversationId,
    );

    return selectedConversation;
  }

  Future<bool> loadConversations(String userId) async {
    final result = await _loadConversationsUseCase?.call(userId);
    if (result != null) {
      conversations.assignAll(result);
      update();
      true;
    }
    return false;
  }

  Future<void> createAndNavigateToChat(String userId) async {
    final conversationId = const Uuid().v4();
    if (_getCurrentUserUseCase != null) {
      final user = await _getCurrentUserUseCase!(userId);
      if (!user.conversationIds!.contains(conversationId)) {
        user.conversationIds?.add(conversationId);
        await _updateUserUseCase!(user);
        final newConversation = ConversationEntity(
            id: conversationId,
            name: 'Cuộc trò chuyện chưa có tiêu đề',
            userId: userId,
            createAt: DateTime.now().toLocal().toString());
        await _createNewConversationUseCase?.call(newConversation);
      }
    }
  }

  void navigateToChat(ConversationEntity conversation) {
    if (conversation.id != null && conversation.id!.isNotEmpty) {
      selectedConversationId(conversation.id);
      Get.toNamed('${PageRouteConstants.chat}/${conversation.id}');
    }
  }
}
