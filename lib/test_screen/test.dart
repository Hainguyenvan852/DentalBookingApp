import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../firebase_options.dart';

import '../view/user_screen/main_screen/chat_bot/chatbot_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Helper',
      home: ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChatbotService _chatbotService = ChatbotService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];

  bool _isLoading = false;
  

  Future<void> _handleSendPressed() async {
    final userMessageText = _textController.text;
    if (userMessageText.isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessageText, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final botResponse = await _chatbotService.sendMessage(userMessageText);

      setState(() {
        _messages.add(ChatMessage(text: botResponse, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại.",
          isUser: false,
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    _messages.add(ChatMessage(isUser: false, text: 'Xin chào! Tôi là trợ lý phòng khám DentalBooking. Bạn có muốn hỏi điều gì không?'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:() => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 19,)),      
        title: Row(
          children: [
            Image.asset('assets/images/gpt-robot.png'),
            SizedBox(width: 10,),
            const Text("Trợ lý DentalBooking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),)
          ],
        ),
        centerTitle: true,
        titleSpacing: 35,
        backgroundColor: Colors.white, 
        elevation: 1,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  LoadingAnimationWidget.waveDots(color: Colors.blue.withOpacity(0.8), size: 40),
                ],
              ),
            ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea( 
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: "Nhập câu hỏi của bạn...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (value) => _handleSendPressed(),
              ),
            ),
            const SizedBox(width: 12.0),
            FloatingActionButton(
              mini: true,
              onPressed: _isLoading ? null : _handleSendPressed,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser ? Colors.blue.withOpacity(0.8) : Colors.grey[200];
    final textColor = isUser ? Colors.white : Colors.black87;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = isUser
        ? const BorderRadius.only(
      topLeft: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(18),
    )
        : const BorderRadius.only(
      topRight: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(18),
    );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isUser ? Text('Bạn', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),) 
            : Text('Trợ lý AI', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ],
      )
    );
  }
}



