import 'package:dental_booking_app/view/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'empty_notif_page.dart';

class OverviewNotifPage extends StatelessWidget {
  OverviewNotifPage({super.key});

  final notifRepo = NotificationRepository();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notifRepo.getOverviewNotif(),
      builder:(context, snap) {
        if (snap.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.blue,)
          );
        }

        return ListView.builder(
          itemCount:snap.data!.isEmpty ? 1 : snap.data!.length,
          itemBuilder: (BuildContext context, int index) {
            if (snap.data!.isEmpty){
              return SizedBox(
                width: double.infinity,
                height: 650,
                  child: EmptyContent()
              );
            }
            return OverviewNotifField(title: 'Thông báo tổng quan', message: snap.data![index].message, createdAt: snap.data![index].createdAt, isRead: snap.data![index].isRead,);
          },
        );
      }
    );
  }
}

class OverviewNotifField extends StatelessWidget {
  const OverviewNotifField({super.key, required this.title, required this.message, required this.createdAt, required this.isRead});
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 110,
        decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),),
                if (!isRead)
                  SvgPicture.asset('assets/icons/mark.svg', width: 10, color: Colors.green,)
              ],
            ),
            Text(message, style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey
            ),),
            Text(DateFormat('dd-MM-yyyy').format(createdAt).toString(), style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey
            ),),
          ],
        ),
      ),
    );
  }
}
