import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const SideMenu({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 26,
                  child: Icon(Icons.person, size: 28),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),

          _menuItem('Tài khoản & hồ sơ', Icons.account_circle),
          _menuItem('Quản lý lịch hẹn', Icons.calendar_today),
          _menuItem('Quản lý người dùng & Phân quyền', Icons.admin_panel_settings),

          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
            Text('Khác', style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon) {
    final bool isActive = (title == selected);
    return InkWell(
      onTap: () => onSelect(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: isActive
            ? BoxDecoration(
          color: Colors.blue.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.blue : Colors.grey[700]),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
