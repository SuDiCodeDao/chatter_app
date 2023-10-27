import 'package:chatter_app/domain/entities/conversation_entity.dart';
import 'package:chatter_app/domain/entities/user_entity.dart';
import 'package:chatter_app/domain/usecases/conversation/load_conversations_usecase.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  LoadConversationsUseCase? _loadConversationsUseCase;
  HomeController({loadConversationUseCase}) {
    _loadConversationsUseCase = loadConversationUseCase;
  }
  @override
  void onInit() {
    final userId = UserEntity().uid;
    loadConversations(userId!);
    super.onInit();
  }

  Future<List<ConversationEntity>> loadConversations(String userId) async {
    final result = await _loadConversationsUseCase?.call(userId);
    if (result != null) {
      conversations.assignAll(result);
      update();
    }
    return conversations;
  }
}
