import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../app/data/datasources/remote/firebase/auth/firebase_auth_datasource.dart';
import '../../app/data/datasources/remote/firebase/auth/firebase_auth_datasource_impl.dart';
import '../../app/data/datasources/remote/firebase/conversation/firebase_conversation_datasource.dart';
import '../../app/data/datasources/remote/firebase/conversation/firebase_conversation_datasource_impl.dart';
import '../../app/data/datasources/remote/firebase/message/firebase_message_datasource.dart';
import '../../app/data/datasources/remote/firebase/message/firebase_message_datasource_impl.dart';
import '../../app/data/datasources/remote/firebase/user/firebase_user_datasource.dart';
import '../../app/data/datasources/remote/firebase/user/firebase_user_datasource_impl.dart';
import '../../app/data/datasources/remote/gpt/gpt_datasource.dart';
import '../../app/data/datasources/remote/gpt/gpt_datasource_impl.dart';
import '../../app/data/repositories/auth_repository_impl.dart';
import '../../app/data/repositories/conversation_repository_impl.dart';
import '../../app/data/repositories/gpt_repository_impl.dart';
import '../../app/data/repositories/message_repository_impl.dart';
import '../../app/data/repositories/user_repository_impl.dart';
import '../../app/domain/repositories/auth_repository.dart';
import '../../app/domain/repositories/conversation_repository.dart';
import '../../app/domain/repositories/gpt_repository.dart';
import '../../app/domain/repositories/message_repository.dart';
import '../../app/domain/repositories/user_repository.dart';
import '../../app/domain/usecases/auth/check_login_usecase.dart';
import '../../app/domain/usecases/auth/get_current_user_usecase.dart';
import '../../app/domain/usecases/auth/send_otp_usecase.dart';
import '../../app/domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../../app/domain/usecases/auth/update_user_profile_usecase.dart';
import '../../app/domain/usecases/auth/verify_otp_usecase.dart';
import '../../app/domain/usecases/chat/create_new_conversation_usecase.dart';
import '../../app/domain/usecases/chat/load_conversations_usecase.dart';
import '../../app/domain/usecases/chat/load_messages_usecase.dart';
import '../../app/domain/usecases/chat/receive_chatbot_response_usecase.dart';
import '../../app/domain/usecases/chat/send_message_usecase.dart';
import '../../app/presentation/controllers/auth_controller.dart';
import '../../app/presentation/controllers/chat_controller.dart';
import '../../app/presentation/controllers/home_controller.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Data sources
  locator.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(
            auth: FirebaseAuth.instance,
          ));

  locator.registerLazySingleton<FirebaseConversationDataSource>(
      () => FirebaseConversationDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ));

  locator.registerLazySingleton<FirebaseMessageDataSource>(
      () => FirebaseMessageDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ));

  locator.registerLazySingleton<FirebaseUserDataSource>(
      () => FirebaseUserDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ));

  locator.registerLazySingleton<GptDataSource>(() => GptDataSourceImpl(
        apiKey: dotenv.env['OPENAI_API_KEY']!,
      ));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        firebaseAuthDataSource: locator<FirebaseAuthDataSource>(),
        firebaseUserDataSource: locator<FirebaseUserDataSource>(),
      ));

  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        firebaseUserDataSource: locator<FirebaseUserDataSource>(),
      ));

  locator.registerLazySingleton<ConversationRepository>(
      () => ConversationRepositoryImpl(
            firebaseConversationDataSource:
                locator<FirebaseConversationDataSource>(),
            firebaseMessageDataSource: locator<FirebaseMessageDataSource>(),
          ));

  locator.registerLazySingleton<GptRepository>(() => GptRepositoryImpl(
        gptDataSource: locator<GptDataSource>(),
        firebaseMessageDataSource: locator<FirebaseMessageDataSource>(),
      ));

  locator.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl(
        firebaseMessageDataSource: locator<FirebaseMessageDataSource>(),
      ));

  // Usecases
  locator.registerLazySingleton<ReceiveChatbotResponseUseCase>(
      () => ReceiveChatbotResponseUseCase(
            gptRepository: locator<GptRepository>(),
          ));

  locator.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCase(
        userRepository: locator<UserRepository>(),
        authRepository: locator<AuthRepository>(),
      ));

  locator
      .registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(
            userRepository: locator<UserRepository>(),
          ));

  locator.registerLazySingleton<CreateNewConversationUseCase>(
      () => CreateNewConversationUseCase(
            conversationRepository: locator<ConversationRepository>(),
          ));

  locator.registerLazySingleton<CheckLoginUseCase>(() => CheckLoginUseCase(
        authRepository: locator<AuthRepository>(),
      ));

  locator.registerLazySingleton<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(
            authRepository: locator<AuthRepository>(),
          ));

  locator.registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(
        authRepository: locator<AuthRepository>(),
      ));

  locator.registerLazySingleton<VerifyOTPUseCase>(() => VerifyOTPUseCase(
        authRepository: locator<AuthRepository>(),
      ));

  locator.registerLazySingleton<LoadConversationsUseCase>(
      () => LoadConversationsUseCase(
            conversationRepository: locator<ConversationRepository>(),
          ));

  locator.registerLazySingleton<LoadMessagesUseCase>(() => LoadMessagesUseCase(
        messageRepository: locator<MessageRepository>(),
      ));

  locator.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(
        messageRepository: locator<MessageRepository>(),
      ));

  // Controllers
  locator.registerLazySingleton(() => AuthController(
        signInWithGoogleUseCase: locator<SignInWithGoogleUseCase>(),
        sendOtpUseCase: locator<SendOtpUseCase>(),
        verifyOTPUseCase: locator<VerifyOTPUseCase>(),
        checkLoginUseCase: locator<CheckLoginUseCase>(),
      ));

  locator.registerLazySingleton(() => HomeController(
        loadConversationUseCase: locator<LoadConversationsUseCase>(),
        getCurrentUserUseCase: locator<GetCurrentUserUseCase>(),
        updateUserUseCase: locator<UpdateUserUseCase>(),
        createNewConversationUseCase: locator<CreateNewConversationUseCase>(),
      ));

  locator.registerSingleton(ChatController(
    sendMessageUseCase: locator<SendMessageUseCase>(),
    receiveChatbotResponseUseCase: locator<ReceiveChatbotResponseUseCase>(),
    loadMessagesUseCase: locator<LoadMessagesUseCase>(),
  ));
}
