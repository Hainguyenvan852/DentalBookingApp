import "package:dental_booking_app/view/doctor_screen/screens/schedule_screen.dart";
import "package:dental_booking_app/view/doctor_screen/screens/setting_screen.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../../data/model/user_model.dart";
import "../../../data/repository/user_repository.dart";

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NavigationAdminPage(),
  ));
}

class NavigationAdminPage extends StatefulWidget{

  const NavigationAdminPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavigationAdminPageState();
  }
}

class _NavigationAdminPageState extends State<NavigationAdminPage>{

  final _userRepo = UserRepository();
  final _auth = FirebaseAuth.instance;

  int _index = 0;
  final pages = [
    const ScheduleScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages,),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i){
          setState(() {
            _index = i;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: "Lịch hẹn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}