import 'package:dental_booking_app/logic/my_appointment_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../logic/appointment_detail_cubit.dart';
import 'appointment_detail_screen.dart';
import 'blinking_box.dart';



class MyAppointmentPage extends StatefulWidget {
  const MyAppointmentPage({super.key});

  @override
  State<MyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<MyAppointmentPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final AppointmentDetailRepository repo;

  @override
  void initState() {
    super.initState();
    repo = AppointmentDetailRepository(userId:_auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => repo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MyAppointmentCubit(repo)..loadForUser()),
          BlocProvider(create: (_) => AppointmentDetailCubit(repo)),
        ],
        child: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Lịch hẹn của tôi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      icon: const Icon(Icons.arrow_back),
                  ),
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )
                  ),
                  backgroundColor: Colors.white,
                ),
                body: BlocBuilder<MyAppointmentCubit, MyAppointmentState>(
                    builder: (context, state){
                      if (state.loading == true){
                        return Center(child: LoadingAnimationWidget.waveDots(
                          color: Colors.blue,
                          size: 35,
                        ),);
                      }
                      if (state.error != null){
                        return Center(child: Text('Error ${state.error.toString()}'),);
                      }

                      return ListView.separated(
                          itemBuilder: (context, index) => AppointmentBox(apmDetail: state.apmDetails[index]),
                          separatorBuilder: (context, index) => SizedBox(height: 8,),
                          itemCount: state.apmDetails.length
                      );
                    }
                )
            ),
        )
      ),
    );
  }

}

class AppointmentBox extends StatelessWidget {

  const AppointmentBox({super.key, required this.apmDetail});

  final AppointmentDetail apmDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        final repo = context.read<AppointmentDetailRepository>();

        final changed = await Navigator.push(context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => AppointmentDetailCubit(repo)
                ..loadDetail(apmDetail.appointment.id),
              child: AppointmentDetailPage(apmId: apmDetail.appointment.id),
            ),
          ),
        );

        if(changed == true){
          await context.read<MyAppointmentCubit>().refreshForPatient();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.yellow[100],
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/yyyy HH:mm').format(apmDetail.appointment.startAt).toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
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
          ],
        ),
      ),
    );
  }
}
