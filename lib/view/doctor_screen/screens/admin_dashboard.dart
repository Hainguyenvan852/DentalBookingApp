import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:dental_booking_app/view/doctor_screen/screens/appointments_screen.dart';
import 'package:dental_booking_app/view/doctor_screen/screens/users_management_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _useRepo = UserRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(),
              
              const SizedBox(height: 50),
              
              const SizedBox(height: 15),
              
              const MenuGridSection(),
            ],
          ),
        ),
      ),
    );
  }
}


class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Chào buổi sáng, Admin!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
        )
      ],
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Lịch hẹn\nhôm nay", "12")),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard("Bệnh nhân\nmới", "5")),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard("Doanh thu", "15M")),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007AFF),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuGridSection extends StatelessWidget {
  const MenuGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "icon": Icons.people_alt_outlined,
        "title": "Người dùng",
        "subtitle": "Quản lý tài khoản",
      },
      {
        "icon": Icons.calendar_month_outlined,
        "title": "Lịch hẹn",
        "subtitle": "Phê duyệt lịch hẹn",
      },
      {
        "icon": Icons.receipt_long_outlined,
        "title": "Đơn hàng",
        "subtitle": "Xem và duyệt đơn",
      },
      {
        "icon": Icons.medical_services_outlined,
        "title": "Điều trị",
        "subtitle": "Theo dõi liệu trình",
      },
      {
        "icon": Icons.folder_shared_outlined,
        "title": "Hồ sơ Bệnh án",
        "subtitle": "Tra cứu thông tin",
      },
      {
        "icon": Icons.bar_chart_rounded,
        "title": "Báo cáo",
        "subtitle": "Thống kê chi tiết",
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), 
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuCard(
          menuItems[index]['icon'],
          menuItems[index]['title'],
          menuItems[index]['subtitle'],
          index,
          context
        );
      },
    );
  }

  Widget _buildMenuCard(IconData icon, String title, String subtitle, int indexFeature, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashFactory: NoSplash.splashFactory,
      onTap: () => fetureOnTap(indexFeature, context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF007AFF),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void fetureOnTap(int index, BuildContext context){
  switch (index){
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen()));
  }
}