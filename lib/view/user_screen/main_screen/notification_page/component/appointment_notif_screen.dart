import 'package:dental_booking_app/data/repository/notification_repository.dart';
import 'package:dental_booking_app/logic/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:dental_booking_app/data/model/notification_model.dart';

import 'empty_notif_screen.dart';

class AppointmentNotifPage extends StatelessWidget {
  AppointmentNotifPage({super.key});

  final notifRepo = NotificationRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notifRepo.getReminderNotif(),
      builder:(context, snap) {
        if (snap.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.blue,)
          );
        }

        return ListView.builder(
          itemCount: snap.data!.isEmpty ? 1 : snap.data!.length,
          itemBuilder: (BuildContext context, int index) {
            if (snap.data!.isEmpty){
              return SizedBox(
                  width: double.infinity,
                  height: 650,
                  child: EmptyContent()
              );
            }
            return AppointmentNotifField(
              notification: snap.data![index],
              repo: notifRepo,
            );
          },
        );
      }
    );
  }
}

class AppointmentNotifField extends StatefulWidget {
  const AppointmentNotifField({super.key, required this.notification, required this.repo});
  final NotificationModel notification;
  final NotificationRepository repo;

  @override
  State<AppointmentNotifField> createState() => _AppointmentNotifFieldState();
}

class _AppointmentNotifFieldState extends State<AppointmentNotifField> {

  late NotificationModel notif;

  @override
  void initState() {
    notif = widget.notification;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!notif.isRead){
          setState(() {
            context.read<NotificationCubit>().load();
            widget.repo.update(notif.copyWith(isRead: true));
            notif = notif.copyWith(isRead: true);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          height: 110,
          decoration: BoxDecoration(
            color: notif.isRead ? Colors.red.shade50 : Colors.blue[50],
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thông báo lịch hẹn', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                  if(!notif.isRead)
                    SvgPicture.asset('assets/icons/mark.svg', width: 10, color: Colors.green,)
                ],
              ),
              Text(widget.notification.message, style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey
              ),),
              Text(DateFormat('dd-MM-yyyy').format(notif.createdAt).toString(), style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
