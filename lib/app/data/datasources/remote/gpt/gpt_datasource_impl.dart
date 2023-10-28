import 'dart:convert';

import 'package:chatter_app/app/data/models/message_model.dart';
import 'package:http/http.dart' as http;

import 'gpt_datasource.dart';

class GptDataSourceImpl extends GptDataSource {
  final String apiUrl = 'https://api.openai.com/v1/completions';
  final String apiKey;

  GptDataSourceImpl({required this.apiKey});

  @override
  Future<MessageModel?> getGptResponse(String prompt) async {
    try {
      Map<String, dynamic> requestBody = {
        'prompt': prompt,
        'model': 'gpt-3.5-turbo-16k-0613',
        'max_tokens': 2000
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('error')) {
          throw Exception(jsonResponse['error']['message']);
        }

        return MessageModel(
          content: jsonResponse['choices'][0]['text'],
          role: 'gpt',
          timeStamp: DateTime.now().toLocal().toString(),
        );
      } else {
        throw Exception('Failed to get a response from GPT-3.5');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
