import 'package:dental_booking_app/view/doctor_screen/screens/create_admin_account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserManagementScreen(),
  ));
}

enum UserRole { doctor, admin, patient}
enum UserStatus { active, locked }

class User {
  final String id;
  final String name;
  final DateTime dob;
  final UserRole role;
  final String phone;
  final String imageUrl;
  final String email;
  final String address;
  final UserStatus status;

  User({
    required this.id,
    required this.name,
    required this.dob,
    required this.email,
    required this.address,
    required this.role,
    required this.phone,
    required this.imageUrl,
    this.status = UserStatus.active,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int _selectedIndex = 0;
  final List<String> _filterOptions = ["Tất cả", "Bác sĩ", "Quản trị", "Bệnh nhân", "Đã khóa"];

  final List<User> _allUsers = [
    User(
      id: '1',
      name: 'Nguyễn Văn An',
      role: UserRole.doctor,
      phone: '0912345678',
      email: 'nguyenvanan@gmail.com',
      address: 'Hà Nội',
      imageUrl: 'https://i.pravatar.cc/150?img=11',
      dob: DateTime(1997, 8, 5)
    ),
    User(
      id: '2',
      name: 'Nguyễn Văn Hải',
      role: UserRole.admin,
      email: 'hainguyenvan852@gmail.com',
      address: 'Hà Nội',
      phone: '0987654321',
      imageUrl: 'https://i.pravatar.cc/150?img=11',
      dob: DateTime(1990, 6, 3)
    ),
    User(
      id: '3',
      name: 'Lê Hoàng Minh',
      role: UserRole.doctor,
      email: 'lehoangminh@gmail.com',
      address: 'Hà Nội',
      phone: '0905112233',
      imageUrl: 'https://i.pravatar.cc/150?img=3',
      dob: DateTime(1985, 7, 12)
    ),
    User(
      id: '4',
      name: 'Phạm Thu Hà',
      role: UserRole.doctor,
      email: 'phamthuha@gmail.com',
      address: 'Hà Nội',
      phone: '0334455667',
      imageUrl: 'https://i.pravatar.cc/150?img=9',
      dob: DateTime(1997, 5, 26)
    ),
    User(
      id: '5',
      name: 'Võ Thành Trung',
      role: UserRole.patient,
      email: 'vothanhtrung@gmail.com',
      address: 'Hà Nội',
      phone: 'Đã khóa',
      imageUrl: 'https://i.pravatar.cc/150?img=8',
      status: UserStatus.locked,
      dob: DateTime(2000, 12, 17)
    ),
    User(
      id: '6',
      name: 'Nguyễn Văn Hải',
      role: UserRole.patient,
      email: 'hainguyenvan1852@gmail.com',
      address: 'Hà Nội',
      phone: '0912345678',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      dob: DateTime(1997, 8, 5)
    ),
    User(
      id: '7',
      name: 'Nguyễn Thế Định',
      role: UserRole.patient,
      email: 'thedinhnguyen@gmail.com',
      address: 'Hà Nội',
      phone: '0912345678',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      dob: DateTime(1997, 8, 5)
    ),
    User(
      id: '8',
      name: 'Trần Hải Đăng',
      role: UserRole.patient,
      email: 'haidangtran@gmail.com',
      address: 'Hà Nội',
      phone: '0912345678',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      dob: DateTime(1997, 8, 5)
    ),
  ];

  List<User> get _filteredUsers {
    switch (_selectedIndex) {
      case 0: 
        return _allUsers.where((u) => u.status == UserStatus.active).toList();
      case 1: 
        return _allUsers.where((u) => u.role == UserRole.doctor && u.status == UserStatus.active).toList();
      case 2: 
        return _allUsers.where((u) => u.role == UserRole.admin && u.status == UserStatus.active).toList();
      case 3:
        return _allUsers.where((u) => u.role == UserRole.patient && u.status == UserStatus.active).toList();
      case 4:
        return _allUsers.where((u) => u.status == UserStatus.locked).toList();
      default:
        return _allUsers;
    }
  }

  String _getRoleName(User user) {
    if (user.status == UserStatus.locked && user.role == UserRole.admin) return "Quản trị - Đã khóa";
    if (user.status == UserStatus.locked && user.role == UserRole.doctor) return "Bác sĩ - Đã khóa";
    if (user.status == UserStatus.locked && user.role == UserRole.patient) return "Bệnh nhân - Đã khóa";

    switch (user.role) {
      case UserRole.doctor: return "Bác sĩ";
      case UserRole.admin: return "Quản trị";
      case UserRole.patient: return "Bệnh nhân";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 19)) ,
        centerTitle: true,
        title: const Text(
          "Quản lý Người dùng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdminScreen())),
            style: IconButton.styleFrom(
              splashFactory: NoSplash.splashFactory
            ),
            icon: const Icon(Icons.add, size: 25, color: Colors.blue,),
          )
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Container(
          //           height: 45,
          //           decoration: BoxDecoration(
          //             color: Colors.grey[200],
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: const TextField(
          //             decoration: InputDecoration(
          //               hintText: "Tìm theo tên, SĐT...",
          //               prefixIcon: Icon(Icons.search, color: Colors.grey),
          //               border: InputBorder.none,
          //               contentPadding: EdgeInsets.symmetric(vertical: 10),
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       Container(
          //         height: 45,
          //         width: 45,
          //         decoration: BoxDecoration(
          //           color: Colors.grey[200],
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: const Icon(Icons.filter_list, color: Colors.black87),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 10,),

          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFD6E4FF) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _filterOptions[index],
                        style: TextStyle(
                          color: isSelected ? Colors.blue[700] : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    final isLocked = user.status == UserStatus.locked;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.imageUrl) ,
                backgroundColor: Colors.grey[300],
              ),
              if (isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock, color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_getRoleName(user)} ${isLocked ? '' : '- ${user.phone}'}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: isLocked ? null : (String value) {
              if (value == 'info') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoScreen(user: user)));
                //_showUserInfo(user);
              } else if (value == 'toggle_lock') {
                _toggleUserLockStatus(user);
              } else if (value == 'contact') {
                contactWithUser(user.phone);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'info',
                child: Text('Xem thông tin'),
              ),
              PopupMenuItem<String>(
                value: 'toggle_lock',
                child: Text(
                  'Vô hiệu hóa',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem<String>(
                value: 'contact',
                child: Text('Liên hệ'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUserInfo(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.name),
        content: Text('Số điện thoại: ${user.phone}\nVai trò: ${_getRoleName(user)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng'))
        ],
      ),
    );
  }

  void _toggleUserLockStatus(User user) {
    setState(() {
      final index = _allUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        final newStatus = user.status == UserStatus.active ? UserStatus.locked : UserStatus.active;
        
        _allUsers[index] = User(
          id: user.id,
          name: user.name,
          role: user.role,
          phone: user.phone,
          imageUrl: user.imageUrl,
          status: newStatus,
          dob: user.dob,
          email: user.email,
          address: user.address
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã vô hiệu hóa tài khoản người dùng ${user.name}')),
    );
  }

  Future<void> contactWithUser(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      print('Không thể thực hiện cuộc gọi đến số $phoneNumber');
      throw 'Could not launch $callUri';
    }
  }
}

class UserInfoScreen extends StatelessWidget {
  final User user;

  const UserInfoScreen({super.key, required this.user});

  String _getRoleName(User user) {
    if (user.status == UserStatus.locked && user.role == UserRole.admin) return "Quản trị - Đã khóa";
    if (user.status == UserStatus.locked && user.role == UserRole.doctor) return "Bác sĩ - Đã khóa";
    if (user.status == UserStatus.locked && user.role == UserRole.patient) return "Bệnh nhân - Đã khóa";

    switch (user.role) {
      case UserRole.doctor: return "Bác sĩ";
      case UserRole.admin: return "Quản trị";
      case UserRole.patient: return "Bệnh nhân";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA), 
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thông tin Người dùng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem("Họ và tên", user.name),
            _buildInfoItem("Số điện thoại", user.phone),
            _buildInfoItem("Email", user.email), 
            _buildInfoItem("Ngày sinh", DateFormat('dd/MM/yyyy').format(user.dob)),
            _buildInfoItem("Vai trò", _getRoleName(user)),
            _buildInfoItem("Địa chỉ", user.address),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF788CA0),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500, 
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

