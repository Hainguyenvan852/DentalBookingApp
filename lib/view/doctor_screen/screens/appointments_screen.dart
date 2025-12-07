import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DentalAppointmentScreen(),
  ));
}

class Appointment {
  final String name;
  final String treatment;
  final String timeStart;
  final String timeEnd;
  final String status; 
  final String imageUrl;

  Appointment({
    required this.name,
    required this.treatment,
    required this.timeStart,
    required this.timeEnd,
    required this.status,
    required this.imageUrl,
  });
}

class DentalAppointmentScreen extends StatefulWidget {
  const DentalAppointmentScreen({super.key});

  @override
  State<DentalAppointmentScreen> createState() =>
      _DentalAppointmentScreenState();
}

class _DentalAppointmentScreenState extends State<DentalAppointmentScreen> {

  final List<Appointment> morningAppointments = [
    Appointment(
      name: "Nguyễn Văn An",
      treatment: "Cạo vôi răng",
      timeStart: "09:00",
      timeEnd: "09:45",
      status: "upcoming",
      imageUrl: "https://i.pravatar.cc/150?img=11",
    ),
    Appointment(
      name: "Trần Thị Bích",
      treatment: "Trám răng sâu",
      timeStart: "10:00",
      timeEnd: "10:30",
      status: "confirmed",
      imageUrl: "https://i.pravatar.cc/150?img=5",
    ),
    Appointment(
      name: "Lê Hoàng Cường",
      treatment: "Khám tổng quát",
      timeStart: "11:00",
      timeEnd: "11:20",
      status: "confirmed",
      imageUrl: "https://i.pravatar.cc/150?img=3",
    ),
    Appointment(
      name: "Phạm Văn D", 
      treatment: "Nhổ răng", 
      timeStart: "11:30", 
      timeEnd: "12:00", 
      status: "confirmed", 
      imageUrl: "https://i.pravatar.cc/150?img=4"
    ),
  ];

  final List<Appointment> afternoonAppointments = [
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: const Icon(Icons.calendar_today, size: 20, color: Colors.black87),
        title: const Text(
          "Hôm nay, 25 tháng 10",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: (){}, 
          style: IconButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap
          ),
          icon: const Icon(Icons.notifications, size: 22, color: Colors.black87),
        )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildViewAllButton(),
              const SizedBox(height: 20),

              const Text("Sáng",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              morningAppointments.isNotEmpty
                  ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: morningAppointments.length,
                        itemBuilder: (context, index) {
                          return AppointmentItem(
                              apt: morningAppointments[index],
                              isLast: index == morningAppointments.length - 1);
                        },
                      )
                  : _buildEmptyState("Buổi sáng của bạn hiện đang trống."),

              const SizedBox(height: 20),

              const Text("Chiều",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              afternoonAppointments.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: afternoonAppointments.length,
                      itemBuilder: (context, index) {
                        return AppointmentItem(
                            apt: afternoonAppointments[index],
                            isLast: index == afternoonAppointments.length - 1);
                      },
                    )
                  : _buildEmptyState("Buổi chiều của bạn hiện đang trống."),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildViewAllButton() {
    return InkWell(
      onTap: () {
        
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grid_view, color: Colors.blue, size: 18),
              SizedBox(width: 8),
              Text("Xem tất cả lịch hẹn",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 40, color: Colors.grey),
              Positioned(
                  bottom: 0,
                  child: Container(color: Colors.white, child: const Icon(Icons.close, size: 20, color: Colors.grey)))
            ],
          ),
          const SizedBox(height: 16),
          const Text("Không có lịch hẹn nào",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {
  final Appointment apt;
  final bool isLast;

  const AppointmentItem({super.key, required this.apt, required this.isLast});

  @override
  Widget build(BuildContext context) {
    bool isUpcoming = apt.status == 'upcoming';
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apt.timeStart,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(apt.timeEnd,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                
                if (!isLast)
                   Expanded(
                    child: Center(
                      child: Container(
                        width: 1, 
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  )
              ],
            ),
          ),
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUpcoming ? const Color(0xFFD6EAF8) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isUpcoming ? Border.all(color: Colors.blue.shade200) : null,
                boxShadow: isUpcoming 
                    ? [] 
                    : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(apt.imageUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(apt.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(apt.treatment,
                            style: TextStyle(
                                color: isUpcoming ? Colors.blue[700] : Colors.grey[600],
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  _buildStatusIcon(apt.status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'upcoming') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("Sắp tới",
            style: TextStyle(color: Color(0xFF856404), fontSize: 11, fontWeight: FontWeight.bold)),
      );
    } else if (status == 'confirmed') {
      return const Icon(Icons.edit, color: Colors.grey, size: 20);
    } else {
      return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.green, size: 16));
    }
  }
}