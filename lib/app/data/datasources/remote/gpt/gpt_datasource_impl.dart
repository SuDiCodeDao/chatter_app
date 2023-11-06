import 'dart:convert';

import 'package:chatter_app/app/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/Uuid.dart';

import '../../../../../core/constants/message_reaction.dart';
import 'gpt_datasource.dart';

class GptDataSourceImpl extends GptDataSource {
  final String apiUrlText = 'https://api.openai.com/v1/completions';
  final String apiUrlImage = 'https://api.openai.com/v1/images/generations';
  final String apiKey;

  GptDataSourceImpl({required this.apiKey});

  @override
  Future<MessageModel?> getGptResponse(String prompt) async {
    try {
      bool isImageRequest = isImageGenerationRequest(prompt);
      String apiUrl;

      if (isImageRequest) {
        apiUrl = apiUrlImage;
      } else {
        apiUrl = apiUrlText;
      }

      final requestObject = buildRequestObject(prompt, isImageRequest);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestObject),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('error')) {
          throw Exception(jsonResponse['error']['message']);
        }

        if (isImageRequest) {
          return processImageResponse(jsonResponse);
        } else {
          return processTextResponse(jsonResponse);
        }
      } else {
        throw Exception('Failed to get a response from GPT-3.5');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  @override
  bool isImageGenerationRequest(String prompt) {
    return prompt.toLowerCase().contains("tạo hình ảnh") ||
        prompt.toLowerCase().contains("ảnh") ||
        prompt.toLowerCase().contains('create image') ||
        prompt.toLowerCase().contains("vẽ") ||
        prompt.toLowerCase().contains("visual");
  }

  @override
  Map<String, dynamic> buildRequestObject(String prompt, bool isImageRequest) {
    if (isImageRequest) {
      return {
        'prompt': prompt,
        'n': 1,
        'response_format': 'url',
        'size': '1024x1024',
      };
    } else {
      return {
        'prompt': prompt,
        'model': 'text-davinci-003',
        'max_tokens': 1000,
        'n': 1,
        'temperature': 0,
        'top_p': 1,
      };
    }
  }

  @override
  MessageModel processTextResponse(dynamic jsonResponse) {
    final text = jsonResponse['choices'][0]['text'];

    return MessageModel(
      id: const Uuid().v4(),
      role: 'gpt',
      reaction: MessageReaction.none,
      content: text.trim(),
      timeStamp: DateTime.now().toLocal().toString(),
    );
  }

  @override
  MessageModel processImageResponse(dynamic jsonResponse) {
    if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
      final List<dynamic> imageDataList = jsonResponse['data'] as List<dynamic>;
      final List<String> imageUrls = [];

      for (final imageData in imageDataList) {
        if (imageData is Map<String, dynamic> && imageData.containsKey('url')) {
          final String imageUrl = imageData['url'] as String;
          imageUrls.add(imageUrl);
        }
      }

      if (imageUrls.isNotEmpty) {
        final String content = imageUrls.join('\n');

        return MessageModel(
          id: const Uuid().v4(),
          role: 'gpt',
          reaction: MessageReaction.none,
          content: content,
          timeStamp: DateTime.now().toLocal().toString(),
        );
      }
    }
    throw Exception('Invalid image response');
  }
}
