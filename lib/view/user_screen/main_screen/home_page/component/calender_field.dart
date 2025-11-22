import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:dental_booking_app/data/repository/appointment_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalenderField extends StatefulWidget {

  const CalenderField({super.key});

  @override
  State<CalenderField> createState() => _CalenderFieldState();
}

class _CalenderFieldState extends State<CalenderField> {

  final _appointmentRepo = AppointmentRepository();
  final _auth = FirebaseAuth.instance;
  late List<Appointment> appointments;
  late final List<NeatCleanCalendarEvent> _eventList;


  @override
  void initState() {
    super.initState();
    _eventList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50],
      height: 290,
      child: FutureBuilder(
          future: _appointmentRepo.getConfirmedAndCompleted(_auth.currentUser!.uid),
          builder: (context, snapshot){

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                  child: CircularProgressIndicator(color: Colors.blue,)
              );
            }
            final appointments = snapshot.data ?? [];

            for (var apm in appointments) {
              if(apm.status == 'completed'){
                _eventList.add(NeatCleanCalendarEvent(
                    apm.ratingNote,
                    isDone: true,
                    startTime: apm.startAt,
                    endTime: apm.endAt)
                );
              }
              else{
                _eventList.add(NeatCleanCalendarEvent(
                    apm.ratingNote,
                    startTime: apm.startAt,
                    endTime: apm.endAt)
                );
              }
            }
            return Calendar(
              showEvents: false,
              showEventListViewIcon: false,
              hideTodayIcon: true,
              startOnMonday: true,
              weekDays: ['Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7', 'CN'],
              eventsList: _eventList,
              isExpandable: false,
              eventDoneColor: Colors.red,
              selectedColor: Colors.pink,
              selectedTodayColor: Colors.red,
              todayColor: Colors.blue,
              eventColor: Colors.green,
              locale: 'vi_VN',
              isExpanded: true,
              expandableDateFormat: 'EEEE, dd MMMM yyyy',
              datePickerType: DatePickerType.date,
              dayOfWeekStyle: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
            );
          }
      )
    );
  }
}


