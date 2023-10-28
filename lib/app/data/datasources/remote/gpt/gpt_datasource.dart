import 'package:chatter_app/app/data/models/message_model.dart';

abstract class GptDataSource {
  Future<MessageModel?> getGptResponse(String prompt);
}
