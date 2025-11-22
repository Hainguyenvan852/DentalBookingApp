import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = {
      'name': 'Admin Chính',
      'email': 'admin@smiledental.vn',
      'phone': '0987 654 321',
      'role': 'Super Admin',
      'joined': '2023-04-10',
      'lastLogin': '2 giờ trước',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Trang cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 36, child: Text(admin['name']![0]), backgroundColor: Colors.blue.shade200),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(admin['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(admin['role']!, style: const TextStyle(color: Colors.black54)),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          ListTile(leading: const Icon(Icons.email), title: Text(admin['email']!)),
          ListTile(leading: const Icon(Icons.phone), title: Text(admin['phone']!)),
          ListTile(leading: const Icon(Icons.calendar_today), title: Text('Tham gia: ${admin['joined']}')),
          ListTile(leading: const Icon(Icons.login), title: Text('Lần đăng nhập cuối: ${admin['lastLogin']}')),
          const Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng xuất (demo)')));
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.logout_sharp),
              label: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ]),
      ),
    );
  }
}
