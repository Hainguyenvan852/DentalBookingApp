import 'package:dental_booking_app/view/repository/appointment_detail_repository.dart';
import 'package:dental_booking_app/view/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'blinking_box.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key, required this.apmDetail});
  final AppointmentDetail apmDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 22,)),
        title: Text('Lịch hẹn của tôi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
        centerTitle: true,
        shape: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            )
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: UserRepository().getUser('fjG3DhpLVtMKXE0eP27w0O3SbYB2'),
          builder: (context, snap){
            if(snap.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(snap.hasError){
              return Text(snap.error.toString());
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        color: Colors.white,
                        height: 280,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            apmDetail.appointment.status == 'confirmed'
                                ? BlinkingContainer(appointment: apmDetail.appointment,)
                                : AppointmentStateBox(appointment: apmDetail.appointment,),
                            SizedBox(height: 10,),
                            Text('Thông tin khách hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/icons/user_outline.svg', height: 24,color: Colors.black54),
                                  //Icon(Icons.person_outline_outlined, size: 24, color: Colors.black54),
                                  SizedBox(width: 15,),
                                  Text(snap.data!.fullName)
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                children: [
                                  Icon(Icons.phone_outlined, size: 22, color: Colors.black54),
                                  SizedBox(width: 15,),
                                  Text(snap.data!.phone)
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month, size: 22, color: Colors.black54),
                                  SizedBox(width: 15,),
                                  Text(DateFormat('dd/MM/yyyy hh:mm').format(snap.data!.dob!).toString(),),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 22, color: Colors.black54),
                                  SizedBox(width: 15,),
                                  Text(snap.data!.address!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 450,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Text('Thông tin điều trị', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 24, color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Chi nhánh', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text(apmDetail.clinic!.name)
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 2,),
                                      Icon(Icons.medical_services_outlined, size: 20, color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Dịch vụ', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text(apmDetail.service!.name)
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/user_outline.svg', height: 24,color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Bác sĩ', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text(apmDetail.dentist!.name)
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 22, color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Ngày hẹn', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text(DateFormat('dd/MM/yyyy').format(apmDetail.appointment.startAt).toString(),),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined, size: 22, color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Giờ hẹn', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text('${DateFormat('hh:mm').format(apmDetail.appointment.startAt).toString()} - '
                                      '${DateFormat('hh:mm').format(apmDetail.appointment.endAt).toString()}',),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.file_copy_outlined, size: 20, color: Colors.black54),
                                      SizedBox(width: 15,),
                                      Text('Nội dung', style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                  Text(apmDetail.appointment.notes, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if(apmDetail.appointment.status == 'completed')
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
                    child: FilledButton(
                      onPressed: (){},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 50),
                        maximumSize: Size(double.infinity, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: Text('Đánh giá'),
                    ),
                  )
                else if (apmDetail.appointment.status == 'pending' || apmDetail.appointment.status == 'confirmed')
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 15),
                    child: FilledButton(
                        onPressed: (){},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 50),
                            maximumSize: Size(double.infinity, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        ),
                        child: Text('Hủy lịch hẹn')
                    ),
                  )
              ],
            );
          }
      )
    );
  }
}
