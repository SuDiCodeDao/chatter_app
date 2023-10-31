import 'package:chatter_app/app/domain/usecases/chat/create_new_conversation_usecase.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/update_user_profile_usecase.dart';
import '../../domain/usecases/chat/load_conversations_usecase.dart';

class HomeController extends GetxController {
  RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  CreateNewConversationUseCase? _createNewConversationUseCase;
  LoadConversationsUseCase? _loadConversationsUseCase;
  GetCurrentUserUseCase? _getCurrentUserUseCase;

  UpdateUserUseCase? _updateUserUseCase;
  final RxString selectedConversationId = "".obs;
  HomeController({loadConversationUseCase, createNewConversationUseCase, getCurrentUserUseCase, updateUserUseCase}) {
    _loadConversationsUseCase = loadConversationUseCase;
    _createNewConversationUseCase = createNewConversationUseCase;
    _getCurrentUserUseCase = getCurrentUserUseCase;
    _updateUserUseCase = updateUserUseCase;
  }
  void selectConversation(String conversationId) {
    selectedConversationId.value = conversationId;
  }

  Future<bool> loadConversations(String userId) async {
    final result = await _loadConversationsUseCase?.call('cIKzo1Op9UTdX6IJnYMEfjiC3mt2');
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
