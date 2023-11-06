import 'package:chatter_app/app/domain/usecases/auth/get_user_by_conversation_id_usecase.dart';
import 'package:chatter_app/app/domain/usecases/auth/sign_out_usecase.dart';
import 'package:chatter_app/app/domain/usecases/auth/update_user_profile_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/create_new_conversation_usecase.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/chat/delete_conversation_usecase.dart';
import '../../domain/usecases/chat/load_conversations_usecase.dart';

class HomeController extends GetxController {
  final isDarkMode = false.obs;
  final RxBool isDeletingConversation = false.obs;
  RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  CreateNewConversationUseCase? _createNewConversationUseCase;
  SignOutUseCase? _signOutUseCase;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  LoadConversationsUseCase? _loadConversationsUseCase;
  GetCurrentUserUseCase? _getCurrentUserUseCase;
  UpdateUserUseCase? _updateUserUseCase;
  GetUserByConversationIdUseCase? _getUserByConversationIdUseCase;
  DeleteConversationUseCase? _deleteConversationUseCase;
  final RxString selectedConversationId = "".obs;

  HomeController({
    loadConversationUseCase,
    signOutUseCase,
    updateUserUseCase,
    getLastMessageUseCase,
    getUserByConversationIdUseCase,
    deleteConversationUseCase,
    createNewConversationUseCase,
    getCurrentUserUseCase,
  }) {
    _loadConversationsUseCase = loadConversationUseCase;

    _updateUserUseCase = _updateUserUseCase;
    _createNewConversationUseCase = createNewConversationUseCase;
    _getCurrentUserUseCase = getCurrentUserUseCase;

    _signOutUseCase = signOutUseCase;
    _getUserByConversationIdUseCase = getUserByConversationIdUseCase;
    _deleteConversationUseCase = deleteConversationUseCase;
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
      if (user.conversationIds?.contains(conversationId) == false) {
        user.conversationIds?.add(conversationId);

        final newConversation = ConversationEntity(
            id: conversationId,
            name: 'Cuộc trò chuyện chưa có tiêu đề',
            userId: userId,
            createAt: DateTime.now().toLocal().toString());
        conversations.add(newConversation);
        if (_updateUserUseCase != null) {
          await _updateUserUseCase!(user);
        }
        if (_createNewConversationUseCase != null) {
          await _createNewConversationUseCase!(newConversation);
        }

        update();
        refresh();
      }
    }
  }

  Future<void> deleteConversation(String userId, String conversationId) async {
    final user = await _getCurrentUserUseCase!(userId);
    if (user.conversationIds!.contains(conversationId)) {
      user.conversationIds?.remove(conversationId);
      await _deleteConversationUseCase!.call(conversationId);
      await _updateUserUseCase!(user);
      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
    }
  }

  Future<void> navigateToChat(
      ConversationEntity conversation, String userId) async {
    if (conversation.id != null && conversation.id!.isNotEmpty) {
      selectedConversationId(conversation.id);
      final rs =
          await Get.toNamed('${PageRouteConstants.chat}/${conversation.id}');
      if (rs != null && rs == true) {
        loadConversations(userId);
      }
    }
  }
}
