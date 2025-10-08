import 'dart:async';
import 'package:dental_booking_app/view/main_ui/notification_page/component/appointment_notif_page.dart';
import 'package:dental_booking_app/view/main_ui/notification_page/component/payment_notif_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../service/authentication_repository.dart';
import '../view/main_ui/notification_page/component/overview_notif_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Thông báo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            centerTitle: true,
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
      )
    );
  }
}



class SignOut extends StatelessWidget {
  SignOut({super.key});

  final _authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _authRepo.signOut, child: Text('dang xuat'));
  }
}



