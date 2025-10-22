import 'package:flutter/material.dart';
import 'component/appointment_notif_page.dart';
import 'component/overview_notif_page.dart';
import 'component/payment_notif_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông báo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Lịch hẹn'),
              Tab(text: 'Thanh toán'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewNotifPage(),
            AppointmentNotifPage(),
            PaymentNotifPage()
          ],
        ),
      ),
    );
  }
}
