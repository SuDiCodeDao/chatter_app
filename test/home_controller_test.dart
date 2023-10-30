import 'package:chatter_app/app/domain/entities/conversation_entity.dart';
import 'package:chatter_app/app/domain/entities/user_entity.dart';
import 'package:chatter_app/app/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:chatter_app/app/domain/usecases/auth/update_user_profile_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/create_new_conversation_usecase.dart';
import 'package:chatter_app/app/domain/usecases/chat/load_conversations_usecase.dart';
import 'package:chatter_app/app/presentation/controllers/home_controller.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockLoadConversationsUseCase extends Mock
    implements LoadConversationsUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

class MockCreateNewConversationUseCase extends Mock
    implements CreateNewConversationUseCase {}

void main() {
  late MockGetCurrentUserUseCase getCurrentUserUseCase;
  late MockUpdateUserUseCase updateUserUseCase;
  late MockCreateNewConversationUseCase createNewConversationUseCase;
  late HomeController homeController;
  late MockLoadConversationsUseCase loadConversationsUseCase;

  setUp(() {
    getCurrentUserUseCase = MockGetCurrentUserUseCase();
    updateUserUseCase = MockUpdateUserUseCase();
    loadConversationsUseCase = MockLoadConversationsUseCase();
    createNewConversationUseCase = MockCreateNewConversationUseCase();
    homeController = HomeController(
        updateUserUseCase: updateUserUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
        createNewConversationUseCase: createNewConversationUseCase,
        loadConversationUseCase: loadConversationsUseCase);
  });
  test('createAndNavigateToChat creates conversation and navigates to chat',
      () async {
    const userId = 'user123';
    const conversationId = 'conv123';
    final user = UserEntity(/* Your UserEntity data here */);
    final newConversation =
        ConversationEntity(/* Your ConversationEntity data here */);

    when(getCurrentUserUseCase(userId)).thenAnswer((_) async => user);
    when(createNewConversationUseCase(newConversation))
        .thenAnswer((_) async => newConversation);

    await homeController.createAndNavigateToChat(userId);

    verify(updateUserUseCase(user)).called(1);
    expect(homeController.conversations, [newConversation]);
    verify(Get.toNamed('${PageRouteConstants.chat}/$conversationId')).called(1);
  });
  test('loadConversations assigns conversations correctly', () async {
    const userId = 'user123';
    final conversations = [
      ConversationEntity(/* Your ConversationEntity data here */)
    ];
    when(loadConversationsUseCase.call(userId))
        .thenAnswer((_) async => conversations);

    await homeController.loadConversations(userId);

    expect(homeController.conversations, conversations);
  });

  test('loadConversations returns true when successful', () async {
    const userId = 'user123';
    when(loadConversationsUseCase.call(userId))
        .thenAnswer((_) async => [/* Your ConversationEntity data here */]);

    final result = await homeController.loadConversations(userId);

    expect(result, true);
  });

  test('loadConversations returns false when an error occurs', () async {
    const userId = 'user123';
    when(loadConversationsUseCase.call(userId))
        .thenThrow(Exception('An error occurred'));

    final result = await homeController.loadConversations(userId);

    expect(result, false);
  });
}
