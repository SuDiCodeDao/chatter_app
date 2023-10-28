import 'package:chatter_app/app/data/datasources/remote/gpt/gpt_datasource.dart';
import 'package:chatter_app/app/domain/entities/message_entity.dart';

import '../../domain/repositories/gpt_repository.dart';

class GptRepositoryImpl extends GptRepository {
  final GptDataSource gptDataSource;

  GptRepositoryImpl({required this.gptDataSource});

  @override
  Future<MessageEntity?> getGptResponse(String prompt) async {
    var messageModel = await gptDataSource.getGptResponse(prompt);
    if (messageModel != null) {
      var messageEntity = messageModel.toEntity();
      return messageEntity;
    }
    return null;
  }
}
