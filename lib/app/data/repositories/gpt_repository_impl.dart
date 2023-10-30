import 'package:chatter_app/app/data/datasources/remote/gpt/gpt_datasource.dart';
import 'package:chatter_app/app/data/models/message_model.dart';
import 'package:chatter_app/app/domain/entities/message_entity.dart';

import '../../domain/repositories/gpt_repository.dart';
import '../datasources/remote/firebase/message/firebase_message_datasource.dart';

class GptRepositoryImpl extends GptRepository {
  final GptDataSource gptDataSource;
  final FirebaseMessageDataSource firebaseMessageDataSource;

  GptRepositoryImpl(
      {required this.gptDataSource, required this.firebaseMessageDataSource});

  @override
  Future<MessageEntity?> getGptResponse(
      String conversationId, String prompt) async {
    var messageModel = await gptDataSource.getGptResponse(prompt);

    if (messageModel != null) {
      await firebaseMessageDataSource.sendMessage(conversationId, messageModel);
      return messageModel.toEntity();
    }
    return null;
  }

  @override
  Future<void> saveBotResponse(
      String conversationId, MessageModel messageModel) async {
    await firebaseMessageDataSource.sendMessage(conversationId, messageModel);
  }
}
