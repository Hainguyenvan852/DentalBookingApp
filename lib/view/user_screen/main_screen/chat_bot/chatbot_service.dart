import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatbotService {

  late final GenerativeModel _model;
  late ChatSession _chat;

  ChatbotService() {
    final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

    final brain = readAssetFile('assets/chatbot_brain.txt');
    brain.then((value){
      final systemInstruction = Content.system(value);

      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        systemInstruction: systemInstruction,
      );

      _chat = _model.startChat();
    });


  }

  Future<String> sendMessage(String userMessage) async {
    try {
      final content = Content.text(userMessage);
      final response = await _chat.sendMessage(content);

      final botResponse = response.text;

      if (botResponse == null) {
        return "Xin lỗi, tôi không thể xử lý yêu cầu này.";
      }

      return botResponse;

    } catch (e) {
      return "Đã xảy ra lỗi, vui lòng thử lại sau. $e";
    }
  }

  Future<String> readAssetFile(String path) async {
    try{
      String contents = await rootBundle.loadString(path);
      return contents;
    } catch(e){
      return "";
    }
  }
}
