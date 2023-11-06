import 'package:chatter_app/app/data/models/message_model.dart';

abstract class GptDataSource {
  Future<MessageModel?> getGptResponse(String prompt);
  MessageModel processTextResponse(dynamic jsonResponse);
  MessageModel processImageResponse(dynamic jsonResponse);
  bool isImageGenerationRequest(String prompt);
  Map<String, dynamic> buildRequestObject(String prompt, bool isImageRequest);
}
