import 'package:chatter_app/app/domain/usecases/chat/create_new_conversation_usecase.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:get/get.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/chat/load_conversations_usecase.dart';

class HomeController extends GetxController {
  RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  CreateNewConversationUseCase? _createNewConversationUseCase;
  LoadConversationsUseCase? _loadConversationsUseCase;
  HomeController({loadConversationUseCase, createNewConversationUseCase}) {
    _loadConversationsUseCase = loadConversationUseCase;
    _createNewConversationUseCase = createNewConversationUseCase;
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
    final newConversation = ConversationEntity.generateRandomId(userId);
    await _createNewConversationUseCase?.call(newConversation);
    Get.toNamed('${PageRouteConstants.chat}/${newConversation.id}');
  }
}
