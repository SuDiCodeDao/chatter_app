import 'package:chatter_app/data/datasources/remote/firebase/auth/firebase_auth_datasource.dart';
import 'package:chatter_app/data/datasources/remote/firebase/conversation/firebase_conversation_datasource.dart';
import 'package:chatter_app/data/datasources/remote/firebase/message/firebase_message_datasource.dart';
import 'package:chatter_app/data/datasources/remote/firebase/message/firebase_message_datasource_impl.dart';
import 'package:chatter_app/data/repositories/auth_repository_impl.dart';
import 'package:chatter_app/domain/repositories/auth_repository.dart';
import 'package:chatter_app/domain/repositories/conversation_repository.dart';
import 'package:chatter_app/domain/usecases/auth/send_otp_usecase.dart';
import 'package:chatter_app/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:chatter_app/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:chatter_app/domain/usecases/conversation/load_conversations_usecase.dart';
import 'package:chatter_app/presentation/controllers/auth_controller.dart';
import 'package:chatter_app/presentation/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../data/datasources/remote/firebase/auth/firebase_auth_datasource_impl.dart';
import '../../data/datasources/remote/firebase/conversation/firebase_conversation_datasource_impl.dart';
import '../../data/datasources/remote/firebase/user/firebase_user_datasource.dart';
import '../../data/datasources/remote/firebase/user/firebase_user_datasource_impl.dart';
import '../../data/repositories/conversation_repository_impl.dart';

class AppInjection {
  Future<void> init() async {
    //controller

    Get.lazyPut<AuthController>(() => AuthController(
        signInWithGoogleUseCase: Get.find<SignInWithGoogleUseCase>(),
        sendOtpUseCase: Get.find<SendOtpUseCase>()));
    Get.lazyPut<HomeController>(() => HomeController(
        loadConversationUseCase: Get.find<LoadConversationsUseCase>()));
    //repositories

    Get.lazyPut<ConversationRepository>(() => ConversationRepositoryImpl(
        firebaseConversationDataSource:
            Get.find<FirebaseConversationDataSource>(),
        firebaseMessageDataSource: Get.find<FirebaseMessageDataSource>()));
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
        firebaseAuthDataSource: Get.find<FirebaseAuthDataSource>(),
        firebaseUserDataSource: Get.find<FirebaseUserDataSource>()));

    //usecase
    Get.lazyPut<LoadConversationsUseCase>(() => LoadConversationsUseCase(
        conversationRepository: Get.find<ConversationRepository>()));
    Get.lazyPut<SignInWithGoogleUseCase>(() =>
        SignInWithGoogleUseCase(authRepository: Get.find<AuthRepository>()));
    Get.lazyPut<SendOtpUseCase>(
        () => SendOtpUseCase(authRepository: Get.find<AuthRepository>()));
    Get.lazyPut<VerifyOTPUseCase>(
        () => VerifyOTPUseCase(authRepository: Get.find<AuthRepository>()));
    //data source
    Get.lazyPut<FirebaseAuthDataSource>(
        () => FirebaseAuthDataSourceImpl(auth: Get.find<FirebaseAuth>()));
    Get.lazyPut<FirebaseConversationDataSource>(() =>
        FirebaseConversationDataSourceImpl(
            firestore: Get.find<FirebaseFirestore>()));
    Get.lazyPut<FirebaseMessageDataSource>(() => FirebaseMessageDataSourceImpl(
        firestore: Get.find<FirebaseFirestore>()));
    Get.lazyPut<FirebaseUserDataSource>(() =>
        FirebaseUserDataSourceImpl(firestore: Get.find<FirebaseFirestore>()));

    //external
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    Get.put(auth, permanent: true);
    Get.put(firestore, permanent: true);
  }
}
