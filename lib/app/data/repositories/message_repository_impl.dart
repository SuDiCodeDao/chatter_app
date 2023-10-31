import 'package:chatter_app/app/data/datasources/remote/firebase/message/firebase_message_datasource.dart';
import 'package:chatter_app/app/data/models/message_model.dart';
import 'package:chatter_app/app/domain/entities/message_entity.dart';
import 'package:chatter_app/app/domain/repositories/message_repository.dart';

class MessageRepositoryImpl extends MessageRepository {
  final FirebaseMessageDataSource firebaseMessageDataSource;

  MessageRepositoryImpl({required this.firebaseMessageDataSource});
  @override
  Future<List<MessageEntity>?> getMessagesInConversation(
      String conversationId) async {
    var listMessageModel = await firebaseMessageDataSource
        .getMessagesInConversation(conversationId);
    print(listMessageModel);
    if (listMessageModel != null) {
      return listMessageModel
          .map((messageModel) => messageModel.toEntity())
          .toList();
    }
    return [];
  }
  //luc dau ham nay tra ve list,messageenitity và có thể là rỗng..

  @override
  Future<void> sendMessage(
      String conversationId, MessageEntity messageEntity) async {
    await firebaseMessageDataSource.sendMessage(
        conversationId, MessageModel.fromEntity(messageEntity));
  }
}
