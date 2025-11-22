import 'dart:io' show Platform;
import 'package:dental_booking_app/view/user_screen/main_screen/support_page/faq_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 19,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Liên Hệ Và Trợ Giúp",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            _buildHeader(size),
            
            Positioned(
              top: size.height * 0.22,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bạn muốn liên hệ với chúng tôi?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Hoặc không tìm thấy câu trả lời bạn đang tìm kiếm?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SupportOptionCard(
                        title: "Message",
                        subtitle: "Nhận trợ giúp từ chuyên gia ngay! Kết nối với đội ngũ hỗ trợ của chúng tôi.",
                        icon: Icons.message,
                        iconColor: Colors.blue.shade700,
                        iconBgColor: Colors.blue.shade50,
                        onPressed: () => messageAction(context),
                      ),
                      SupportOptionCard(
                        title: "FAQs",
                        subtitle: "Tìm câu trả lời nhanh chóng! Đọc phần câu hỏi thường gặp của chúng tôi.",
                        icon: Icons.question_answer,
                        iconColor: Colors.orange.shade700,
                        iconBgColor: Colors.orange.shade50,
                        onPressed: () => faqAction(context),
                      ),
                      SupportOptionCard(
                        title: "Email",
                        subtitle: "Gửi email cho chúng tôi và chúng tôi sẽ sớm phản hồi bạn.",
                        icon: Icons.email,
                        iconColor: Colors.purple.shade700,
                        iconBgColor: Colors.purple.shade50,
                        onPressed: () => emailAction(context),
                      ),
                      const SizedBox(height: 24),
                      _buildContactUsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 28, 143, 237), 
            Color.fromARGB(255, 163, 209, 242),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight, 
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent_rounded, color: Colors.white.withOpacity(0.8), size: 60),
          const SizedBox(height: 12),
          const Text(
            "Bạn Gặp Vấn Đề?",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giúp đỡ khi bạn cần.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildContactUsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF9E7FE), 
            const Color(0xFFE8EDFE), 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight, 
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Liên hệ với chúng tôi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                ContactInfoRow(
                  icon: Icons.phone_outlined,
                  text: "+84 974-106-232",
                ),
                const SizedBox(height: 12),
                ContactInfoRow(
                  icon: Icons.language,
                  text: "www.goslash.com",
                ),
                const SizedBox(height: 12),
                ContactInfoRow(
                  icon: Icons.email_outlined,
                  text: "support@dental.com",
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 12,),
              Icon(Icons.camera_alt_outlined, color: Colors.grey.shade700, size: 20),
              const SizedBox(height: 12),
              Icon(Icons.public, color: Colors.grey.shade700, size: 20),
              const SizedBox(height: 12),
              Icon(Icons.facebook, color: Colors.grey.shade700, size: 20),
              const SizedBox(height: 12),
              Icon(Icons.play_circle_outline, color: Colors.grey.shade700, size: 20),
            ],
          )
        ],
      ),
    );
  }


  void messageAction(BuildContext context) async{
    String url;
    String facebookId ='61584109139069';

      if (Platform.isAndroid) {
        //url = 'fb-messenger://user-thread/$facebookId';
        String message = "Tôi muốn được hỗ trợ";
        url = 'https://m.me/$facebookId?text=${Uri.encodeComponent(message)}';
      } else if (Platform.isIOS) {
        url = 'https://m.me/$facebookId';
      } else {
        print('Unsupported platform');
        return;
      }

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
  }

  void emailAction(BuildContext context){

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    
    final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Hãy viết yêu cầu cần hỗ trợ của bạn',
    }),
  );

  launchUrl(emailLaunchUri);
  }

  void faqAction(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => FAQScreen())
    );
  }
}

class SupportOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onPressed;

  const SupportOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 20),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}