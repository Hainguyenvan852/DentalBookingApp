import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'medical_record_screen.dart';


class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.detail});
  final AppointmentDetail detail ;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context, true), icon: const Icon(Icons.arrow_back),),
          title: Text('Chi tiết lịch hẹn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
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
            future: UserRepository().getUser(widget.detail.appointment.patientId),
            builder: (context, snap){
              if(snap.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.blue,),);
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
                          height: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              _appointmentStateBox(),
                              SizedBox(height: 10,),
                              Text('Thông tin khách hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              SizedBox(height: 20,),
                              SizedBox(
                                height: 25,
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/user_outline.svg', height: 24,color: Colors.black54),
                                    SizedBox(width: 15,),
                                    Text(snap.data!.fullName!)
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
                                    Text(snap.data!.phone!)
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
                                    Text(DateFormat('dd/MM/yyyy').format(snap.data!.dob!).toString(),),
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
                              SizedBox(height: 20,),
                              if(widget.detail.appointment.isBookingForAnother)
                                Text("**Đặt lịch hẹn cho người thân**"),
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
                                    Text(widget.detail.clinic!.name)
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
                                    Text(widget.detail.service!.name)
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
                                    Text(widget.detail.dentist!.name)
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
                                    Text(DateFormat('dd/MM/yyyy').format(widget.detail.appointment.startAt).toString(),),
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
                                    Text('${DateFormat('HH:mm').format(widget.detail.appointment.startAt).toString()} - '
                                        '${DateFormat('HH:mm').format(widget.detail.appointment.endAt).toString()}',),
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
                                    Text(widget.detail.appointment.ratingNote, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
                    child: FilledButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalRecordScreen(patientId: widget.detail.appointment.patientId))),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50),
                          maximumSize: Size(double.infinity, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                      child: Text('Xem lịch sử bệnh án'),
                    ),
                  )
                ],
              );
            }
        )
    );
  }

  Widget _appointmentStateBox(){
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Center(child: Text('Sắp tới', style: TextStyle(color: Color(0xFFD97706), fontSize: 12),)),
    );
  }

}