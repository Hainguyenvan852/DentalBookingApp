import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.notifications_off_sharp, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text('Hiện không có thông báo nào', style: TextStyle(fontSize: 16, color: Colors.black54)),
        ]),
      ),
    );
  }
}
