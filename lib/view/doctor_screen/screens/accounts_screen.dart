import 'package:flutter/material.dart';

class Account {
  String id;
  String name;
  String role;
  String phone;
  String email;

  Account({required this.id, required this.name, required this.role, required this.phone, required this.email});
}

class AccountsScreen extends StatefulWidget {
  final String searchQuery;
  const AccountsScreen({super.key, this.searchQuery = ''});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late List<Account> _accounts;

  @override
  void initState() {
    super.initState();
    _accounts = [
      Account(id: 'aa1', name: 'Nguyễn Văn An', role: 'Admin', phone: '0987654321', email: 'an@smiledental.vn'),
      Account(id: 'aa2', name: 'Lê Thị Hoa', role: 'Patient', phone: '0912345678', email: 'hoa@patient.vn'),
      Account(id: 'aa3', name: 'Phạm Văn B', role: 'Doctor', phone: '0909123456', email: 'pb@smiledental.vn'),
    ];
  }

  List<Account> _filtered() {
    final q = widget.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _accounts;
    return _accounts.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.role.toLowerCase().contains(q) ||
          a.phone.toLowerCase().contains(q) ||
          a.email.toLowerCase().contains(q);
    }).toList();
  }

  void _openEdit(Account a) {
    final nameCtrl = TextEditingController(text: a.name);
    final roleCtrl = TextEditingController(text: a.role);
    final phoneCtrl = TextEditingController(text: a.phone);
    final emailCtrl = TextEditingController(text: a.email);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa tài khoản'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên')),
            TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Vai trò')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                a.name = nameCtrl.text.trim();
                a.role = roleCtrl.text.trim();
                a.phone = phoneCtrl.text.trim();
                a.email = emailCtrl.text.trim();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu')));
            },
            child: const Text('Lưu'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 6),
      const Text('Tài khoản & hồ sơ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty
            ? const Center(child: Text('Không tìm thấy tài khoản'))
            : ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final a = list[i];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(child: Text(a.name.substring(0, 1))),
                title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${a.role} • ${a.phone}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'view') {
                      showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text(a.name),
                        content: Text('Email: ${a.email}\nRole: ${a.role}\nPhone: ${a.phone}'),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
                      ));
                    }
                    if (v == 'edit') _openEdit(a);
                    if (v == 'logout') ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng xuất (demo)')));
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'view', child: Text('Xem thông tin')),
                    PopupMenuItem(value: 'edit', child: Text('Sửa thông tin')),
                    PopupMenuItem(value: 'logout', child: Text('Đăng xuất')),
                  ],
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
