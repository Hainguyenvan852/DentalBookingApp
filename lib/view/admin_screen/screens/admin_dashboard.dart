import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import 'accounts_screen.dart';
import 'appointments_screen.dart';
import 'users_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminDashboard(),
  ));
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  bool _isSearching = false;
  String _searchQuery = '';

  final List<String> _titles = [
    'Tài khoản & hồ sơ',
    'Quản lý lịch hẹn',
    'Người dùng & Phân quyền',
  ];

  void _onSearchToggle() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchQuery = '';
    });
  }

  void _onQueryChanged(String q) {
    setState(() => _searchQuery = q);
  }

  void _openNotifications() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
  }

  void _openProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      AccountsScreen(searchQuery: _isSearching ? _searchQuery : ''),
      AppointmentsScreen(searchQuery: _isSearching ? _searchQuery : ''),
      UsersScreen(searchQuery: _isSearching ? _searchQuery : ''),
    ];

    return Scaffold(
      appBar: TopBar(
        title: _titles[_currentIndex],
        isSearching: _isSearching,
        searchQuery: _searchQuery,
        onSearchToggle: _onSearchToggle,
        onQueryChanged: _onQueryChanged,
        onNotifications: _openNotifications,
        onProfile: _openProfile,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            // reset search when switching screens if you like:
            // _isSearching = false; _searchQuery = '';
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group_sharp), label: 'Tài khoản'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_sharp), label: 'Lịch hẹn'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_sharp), label: 'Người dùng'),
        ],
      ),
    );
  }
}
