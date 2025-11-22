import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {

  static const String _apiKey = "AIzaSyCM7yqTuqEgDPPj5YcycspkqIhdPSnvhR0";

  late final GenerativeModel _model;
  late ChatSession _chat;

  ChatbotService() {

    // Đây là "linh hồn" của chatbot, quy định vai trò của nó.
    final systemInstruction = Content.system(
        "Bạn là một trợ lý chatbot của phòng khám nha khoa DentalBooking. "
            "Nhiệm vụ của bạn là trả lời các thắc mắc của khách hàng một cách thân thiện, chuyên nghiệp và ngắn gọn. "
            "Các dịch vụ chính của nha khoa là khám tổng quát, niềng răng, làm răng sứ và các dịch vụ khác."
            "Các chi nhánh của nha khoa gồm: Chi nhánh Cầu Giấy(247 P. Cầu Giấy, Dịch Vọng, Cầu Giấy, Hà Nội) - Số điện thoại: 0979755521, "
            "Chi nhánh Đống Đa(148 P. Chùa Láng, Láng Thượng, Đống Đa, Hà Nội) - Số điện thoại: 0363645457"
            "Chi nhánh Hai Bà Trưng(1 P. Bạch Mai, Thanh Nhàn, Hai Bà Trưng, Hà Nội) - Số điện thoại: 0785463215"
            "Lịch làm việc của tất cả chi nhánh từ 8h sáng đến 19h tối"
            "KHÔNG được bịa đặt thông tin. Nếu không biết câu trả lời, hãy nói: "
            "Xin lỗi, tôi chưa có thông tin này. Tôi sẽ chuyển câu hỏi của bạn đến bộ phận hỗ trợ."
            "Bạn có thể liên hệ tới bộ phận hỗ trợ qua số điện thoại 0979755521 để được hỗ trợ."
    );

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: systemInstruction,
    );

    _chat = _model.startChat();
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
      return "Đã xảy ra lỗi, vui lòng thử lại sau.";
    }
  }
}