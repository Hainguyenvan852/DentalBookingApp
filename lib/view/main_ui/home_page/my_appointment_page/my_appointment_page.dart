import 'package:flutter/material.dart';
import 'package:dental_booking_app/view/repository/appointment_detail_repository.dart';
import 'package:intl/intl.dart';

import 'appointment_detail_page.dart';
import 'blinking_box.dart';



class MyAppointmentPage extends StatelessWidget {
  const MyAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lịch hẹn của tôi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
          centerTitle: true,
          leading: IconButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), icon: Icon(Icons.arrow_back_ios, size: 22,)),
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              )
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
            future: AppointmentDetailRepository(userId: 'fjG3DhpLVtMKXE0eP27w0O3SbYB2').getAppointmentDetail(),
            builder: (context, snap){
              if(snap.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }

              if(snap.hasError){
                return Text('Error: ${snap.error.toString()}');
              }
              return ListView.separated(
                  itemBuilder: (context, index) => AppointmentBox(apmDetail: snap.data![index],),
                  separatorBuilder: (context, index) => SizedBox(height: 8,),
                  itemCount: snap.data!.length
              );
            }
        )
    );;
  }
}

class AppointmentBox extends StatelessWidget {

  const AppointmentBox({super.key, required this.apmDetail});

  final AppointmentDetail apmDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(apmDetail: apmDetail,))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.yellow[100],
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/yyyy hh:mm').format(apmDetail.appointment.startAt).toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
            SizedBox(height: 8,),
            apmDetail.appointment.status == 'confirmed'
                ? BlinkingContainer(appointment: apmDetail.appointment,)
                : AppointmentStateBox(appointment: apmDetail.appointment,),
            SizedBox(height: 8,),
            SizedBox(
              height: 25,
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 22, color: Colors.black54),
                  SizedBox(width: 5,),
                  Text('Chi nhánh', style: TextStyle(color: Colors.black54),),
                  SizedBox(width: 40,),
                  Text(apmDetail.clinic!.name)
                ],
              ),
            ),
            SizedBox(height: 8,),
            SizedBox(
              height: 25,
              child: Row(
                children: [
                  Icon(Icons.person_outline_outlined, size: 22, color: Colors.black54),
                  SizedBox(width: 5,),
                  Text('Bác sĩ', style: TextStyle(color: Colors.black54),),
                  SizedBox(width: 65,),
                  Text(apmDetail.dentist!.name)
                ],
              ),
            ),
            SizedBox(height: 8,),
            SizedBox(
              height: 25,
              child: Row(
                children: [
                  Icon(Icons.medical_services_outlined, size: 22, color: Colors.black54),
                  SizedBox(width: 5,),
                  Text('Dịch vụ', style: TextStyle(color: Colors.black54),),
                  SizedBox(width: 58,),
                  Text(apmDetail.service!.name)
                ],
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.file_copy_outlined, size: 20, color: Colors.black54),
                      SizedBox(width: 5,),
                      Text('Nội dung', style: TextStyle(color: Colors.black54),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(apmDetail.appointment.notes)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
