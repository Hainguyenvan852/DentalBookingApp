import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:dental_booking_app/data/repository/appointment_repository.dart';
import 'package:dental_booking_app/data/repository/notification_repository.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cart_page.dart';
import '../../notification_page/notification_page.dart';

class NavBar extends StatefulWidget {

  const NavBar({super.key,});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final _userRepo = UserRepository();
  final _appointmentRepo = AppointmentRepository();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: _userRepo.getUser(_auth.currentUser!.uid),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                constraints: BoxConstraints(
                                    minHeight: 18,
                                    minWidth: 18
                                ),
                              )
                          );
                        }

                        final user = snapshot.data!;

                        return Text('Xin chào ${user.fullName}', style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: FutureBuilder(
                      future: _appointmentRepo.getTodayAppointment(_auth.currentUser!.uid),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                constraints: BoxConstraints(
                                  minHeight: 12,
                                  minWidth: 12
                                ),
                              )
                          );
                        }

                        final List<Appointment> appointments = snapshot.data ?? [];

                        if(appointments.isEmpty){
                          return Text('Hôm nay bạn không có lịch hẹn',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                              )
                          );
                        }
                        else {
                          return Text('Hôm nay bạn có ${appointments.length} lịch hẹn',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                              )
                          );
                        }
                      },
                    ),
                  )
                ],
              )
            ),
            SizedBox(
              width: 48,
            ),
            IconButton(
              onPressed: () => cartOnPressed(context),
              icon: SvgPicture.asset('assets/icons/shopping-cart.svg', width: 21,),
            ),
            IconButton(
              onPressed: () => notificationOnPressed(context),
              icon: SvgPicture.asset('assets/icons/notification.svg', width: 20,),
            ),
          ],
        ),
      ),
    );
  }
}

void notificationOnPressed(BuildContext context){
  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => NotificationPage()
      )
  );
}

void cartOnPressed(BuildContext context){
  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CartScreen()
      )
  );
}
