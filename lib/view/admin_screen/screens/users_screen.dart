// (This is the same UsersScreen as before but with constructor param searchQuery)
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String email;
  String role;
  String phone;
  bool active;
  List<String> permissions;
  DateTime createdAt;
  DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.active = true,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? lastLogin,
  })  : permissions = permissions ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now();
}

class UsersScreen extends StatefulWidget {
  final String searchQuery;
  const UsersScreen({super.key, this.searchQuery = ''});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late List<User> _users;

  @override
  void initState() {
    super.initState();
    _users = [
      User(
        id: 'u1',
        name: 'Nguyễn Văn An',
        email: 'an.nguyen@smiledental.vn',
        role: 'Bác sĩ',
        phone: '0987654321',
        permissions: ['Xem lịch hẹn', 'Thêm lịch', 'Sửa hồ sơ'],
        createdAt: DateTime(2024, 5, 12),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      User(
        id: 'u2',
        name: 'Trần Thị Bình',
        email: 'binh.tran@smiledental.vn',
        role: 'Reception',
        phone: '0912345678',
        permissions: ['Xem lịch hẹn'],
        createdAt: DateTime(2023, 11, 1),
        lastLogin: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // ... (same helper methods _openAddEdit, _confirmDelete, _openPermissions, _buildTile)
  // For brevity, reuse the same implementations from previous UsersScreen (they will work the same).
  // But we must ensure that build filters by widget.searchQuery.

  void _openAddEdit({User? user}) {
    final isEdit = user != null;
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final roleCtrl = TextEditingController(text: user?.role ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    bool active = user?.active ?? true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setD) {
        return AlertDialog(
          title: Text(isEdit ? 'Sửa người dùng' : 'Thêm người dùng'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Họ tên')),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Vai trò')),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Kích hoạt'),
                    const Spacer(),
                    Switch(value: active, onChanged: (v) => setD(() => active = v)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tên không được để trống')));
                  return;
                }
                setState(() {
                  if (isEdit) {
                    user!.name = nameCtrl.text.trim();
                    user.email = emailCtrl.text.trim();
                    user.role = roleCtrl.text.trim();
                    user.phone = phoneCtrl.text.trim();
                    user.active = active;
                    user.lastLogin = DateTime.now();
                  } else {
                    _users.add(User(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      role: roleCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      active: active,
                      permissions: [],
                    ));
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'Đã cập nhật' : 'Đã thêm người dùng')));
              },
              child: Text(isEdit ? 'Lưu' : 'Thêm'),
            ),
          ],
        );
      }),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa người dùng'),
        content: Text('Bạn có chắc muốn xóa "${user.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _openPermissions(User user) {
    final available = [
      'Xem lịch hẹn',
      'Thêm lịch',
      'Sửa lịch',
      'Xóa lịch',
      'Xem hồ sơ bệnh nhân',
      'Cập nhật hồ sơ',
    ];
    final current = List<String>.from(user.permissions);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setD) {
        return AlertDialog(
          title: Text('Phân quyền - ${user.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: available.map((p) {
                final checked = current.contains(p);
                return CheckboxListTile(
                  value: checked,
                  onChanged: (v) {
                    setD(() {
                      if (v == true) {
                        current.add(p);
                      } else {
                        current.remove(p);
                      }
                    });
                  },
                  title: Text(p),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                setState(() => user.permissions = current);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật phân quyền')));
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTile(User u) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[50],
      child: ListTile(
        leading: CircleAvatar(child: Text(u.name.substring(0, 1))),
        title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${u.role} • ${u.phone}'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') _openAddEdit(user: u);
            if (v == 'delete') _confirmDelete(u);
            if (v == 'perm') _openPermissions(u);
            if (v == 'view') {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(u.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${u.email}'),
                      Text('Vai trò: ${u.role}'),
                      Text('SĐT: ${u.phone}'),
                      Text('Trạng thái: ${u.active ? 'Active' : 'Disabled'}'),
                      Text('Quyền: ${u.permissions.join(', ')}'),
                    ],
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
                ),
              );
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'view', child: Text('Xem thông tin')),
            PopupMenuItem(value: 'perm', child: Text('Phân quyền')),
            PopupMenuItem(value: 'edit', child: Text('Sửa thông tin')),
            PopupMenuItem(value: 'delete', child: Text('Xóa người dùng')),
          ],
        ),
      ),
    );
  }

  List<User> _filtered() {
    final q = widget.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _users;
    return _users.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.role.toLowerCase().contains(q) ||
          u.phone.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        ElevatedButton.icon(
          onPressed: () => _openAddEdit(),
          icon: const Icon(Icons.person_add_sharp),
          label: const Text('Thêm người dùng'),
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Không tìm thấy người dùng'))
              : ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _buildTile(filtered[i]),
          ),
        ),
      ],
    );
  }
}
