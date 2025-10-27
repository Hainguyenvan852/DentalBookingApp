import 'package:dental_booking_app/logic/appointment_detail_cubit.dart';
import 'package:dental_booking_app/view/main_ui/home_page/my_appointment_page/rating_screen.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'blinking_box.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.apmId});
  final String apmId;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
        builder: (context, state){
          if (state.loading == true){
            return Center(child: CircularProgressIndicator(),);
          }

          if (state.error != null){
            return Center(child: Text('Error ${state.error.toString()}'),);
          }

          return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                leading: IconButton(onPressed: () => Navigator.pop(context, true), icon: Icon(Icons.arrow_back_ios, size: 19,)),
                title: Text('Chi tiết lịch hẹn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
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
                  future: UserRepository().getUser(_auth.currentUser!.uid),
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
                                    state.detail!.appointment.status == 'confirmed'
                                        ? BlinkingContainer(appointment: state.detail!.appointment,)
                                        : AppointmentStateBox(appointment: state.detail!.appointment,),
                                    SizedBox(height: 10,),
                                    Text('Thông tin khách hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    SizedBox(height: 20,),
                                    SizedBox(
                                      height: 25,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/icons/user_outline.svg', height: 24,color: Colors.black54),
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
                                          Text(state.detail!.clinic!.name)
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
                                          Text(state.detail!.service!.name)
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
                                          Text(state.detail!.dentist!.name)
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
                                          Text(DateFormat('dd/MM/yyyy').format(state.detail!.appointment.startAt).toString(),),
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
                                          Text('${DateFormat('hh:mm').format(state.detail!.appointment.startAt).toString()} - '
                                              '${DateFormat('hh:mm').format(state.detail!.appointment.endAt).toString()}',),
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
                                          Text(state.detail!.appointment.notes, overflow: TextOverflow.ellipsis,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        if(state.detail!.appointment.status == 'completed')
                          if(state.detail!.appointment.rating == 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
                              child: FilledButton(
                                onPressed: () async {
                                  final submit = await showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                        actionsPadding: EdgeInsets.only(left: 5, bottom: 10, right: 5),
                                        content: RatingScreen(appointment: state.detail!.appointment,),
                                      );
                                  });

                                  if(submit == true){
                                    await context.read<AppointmentDetailCubit>().loadDetail(widget.apmId);
                                  }
                                },
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
                          else
                            Padding(
                              padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
                              child: FilledButton(
                                onPressed: null,
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, 50),
                                    maximumSize: Size(double.infinity, 100),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                                child: Text('Đã đánh giá'),
                              ),
                            )
                        else if (state.detail!.appointment.status == 'pending' || state.detail!.appointment.status == 'confirmed')
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
    );
  }
}
