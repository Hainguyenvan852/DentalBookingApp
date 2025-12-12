import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:dental_booking_app/logic/my_appointment_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../firebase_options.dart';
import 'detail_appointment_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: AllAppointmentsScreen(),
  ));
}


class AllAppointmentsScreen extends StatefulWidget {
  const AllAppointmentsScreen({super.key});

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {

  final _detailRepo = AppointmentDetailRepository(userId: 'staff#5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Tất cả lịch hẹn",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<MyAppointmentCubit, MyAppointmentState>(
          builder: (context, state) {
            if (state.loading == true) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.blue,
                  size: 35,
                ),
              );
            }

            if (state.error != null) {
              return Center(child: Text('Error ${state.error.toString()}'));
            }

            final details = filterByStatus(state.apmDetails);

            return Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: details.isNotEmpty ?
                ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return _buildAppointmentCard(details[index], (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(detail: details[index],)));
                    });
                  },
                ) :
                Center(
                  child: Text('Hôm nay bạn không có lịch hẹn nào'),
                )
            );
          },
        ),
    );
  }

  Widget _buildAppointmentCard(AppointmentDetail detail, VoidCallback onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.blue.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${detail.appointment.startAt.day}/${detail.appointment.startAt.month}/${detail.appointment.startAt.year}  ${detail.appointment.startAt.hour}:${detail.appointment.startAt.minute} - ${detail.appointment.endAt.hour}:${detail.appointment.endAt.minute}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Sắp tới',
                    style: TextStyle(color: const Color(0xFFD97706), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 15),

            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.patient!.fullName!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.service!.name,
                        style: const TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.green, size: 22,),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<AppointmentDetail> filterByStatus(List<AppointmentDetail> details)
  => details.where((detail) => detail.appointment.status == 'confirmed')
      .toList();
}