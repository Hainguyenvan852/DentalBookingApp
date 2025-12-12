import 'package:dental_booking_app/logic/appointment_detail_cubit.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/my_appointment_page/cancel_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/my_appointment_page/rating_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/my_appointment_page/reschedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../data/model/appointment_model.dart';
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
            return Scaffold(body: Center(child: LoadingAnimationWidget.waveDots(
              color: Colors.blue,
              size: 35,
            )));
          }

          if (state.error != null){
            return Scaffold(body: Center(child: Text('Error ${state.error.toString()}'),));
          }

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
                  future: UserRepository().getUser(_auth.currentUser!.uid),
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
                                    if(state.detail!.appointment.isBookingForAnother)
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
                                          Text('${DateFormat('HH:mm').format(state.detail!.appointment.startAt).toString()} - '
                                              '${DateFormat('HH:mm').format(state.detail!.appointment.endAt).toString()}',),
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
                                          Text(state.detail!.appointment.ratingNote, overflow: TextOverflow.ellipsis,),
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
                        else if (state.detail!.appointment.status == 'confirmed')
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 15),
                            child: Column(
                              children: [
                                Text('* Phòng khám khuyến khích hủy lịch sớm ít nhất 24 tiếng để sắp xếp bác sĩ và thiết bị',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                FilledButton(
                                    onPressed: (){
                                      final difference = DateTime.now().difference(state.detail!.appointment.startAt);
                                      final detailCubit = context.read<AppointmentDetailCubit>();
                                      if(difference.inHours >= 24){
                                        showCancelBooking(context, detailCubit, state.detail!.appointment);
                                      }
                                      else{
                                        showCancelBookingOverTime(context, detailCubit, state.detail!.appointment);
                                      }
                                    },
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
                              ],
                            ),
                          )
                        else if (state.detail!.appointment.status == 'canceled_by_patient' || state.detail!.appointment.status == 'canceled_by_clinic')
                            Padding(
                              padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 15),
                              child: FilledButton(
                                  onPressed: null,
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: Size(double.infinity, 50),
                                      maximumSize: Size(double.infinity, 100),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                      )
                                  ),
                                  child: Text('Đã hủy')
                              ),
                            )
                        else if (state.detail!.appointment.status == 'pending')
                              Padding(
                                padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 15),
                                child: Column(
                                  children: [
                                    Text('* Phòng khám khuyến khích hủy lịch sớm ít nhất 24 tiếng để sắp xếp bác sĩ và thiết bị',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    FilledButton(
                                        onPressed: (){
                                          final detailCubit = context.read<AppointmentDetailCubit>();
                                          showCancelBooking(context, detailCubit, state.detail!.appointment);
                                        },
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
                                  ],
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

Future<void> showCancelBooking(BuildContext context, AppointmentDetailCubit cubit, Appointment apm) {
  //const Color darkTeal = Color(0xFF0B5F6C);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      padding: EdgeInsets.fromLTRB(
        0,
        5,
        0,
        24 + MediaQuery.of(context).viewPadding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Hủy Lịch Hẹn',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.cancel_rounded, color: Colors.grey[600]),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(height: 0.7, width: double.infinity, color: Colors.grey,),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              'Bạn chắc chắn muốn hủy lịch hẹn này chứ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade400,
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: CancelBookingScreen(apm: apm,),
                              )
                          )
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  );
}

Future<void> showCancelBookingOverTime(BuildContext context, AppointmentDetailCubit cubit, Appointment apm) {
  //const Color darkTeal = Color(0xFF0B5F6C);

  return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
          0,
          5,
          0,
          24 + MediaQuery.of(context).viewPadding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Hủy Lịch Hẹn',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.cancel_rounded, color: Colors.grey[600]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(height: 0.7, width: double.infinity, color: Colors.grey,),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Nếu hủy lịch hẹn bạn sẽ bị trừ điểm uy tín với nha khoa do hủy sau 24 tiếng.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Bạn vẫn muốn hủy lịch hẹn này chứ?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                              BlocProvider.value(
                                value: cubit,
                                child: RescheduleScreen(appointment: apm,),
                              )
                        ));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade400,
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Đổi khung thời gian",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: cubit,
                                  child: CancelBookingScreen(apm: apm,),
                                )
                            )
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận hủy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
  );
}
