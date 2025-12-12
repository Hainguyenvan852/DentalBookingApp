import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:dental_booking_app/logic/my_appointment_cubit.dart';
import 'package:dental_booking_app/view/doctor_screen/screens/notifications_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../firebase_options.dart';
import 'all_appointment_screen.dart';
import 'detail_appointment_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: ScheduleScreen(),
  ));
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedValue = DateTime.now();
  final _detailRepo = AppointmentDetailRepository(userId: 'staff#5');

  final DatePickerController _datePickerController = DatePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickerController.animateToDate(DateTime.now().subtract(const Duration(days: 2)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _detailRepo,
      child: BlocProvider(
        create: (context) => MyAppointmentCubit(_detailRepo)..loadForDoctor(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),

                const SizedBox(height: 20),

                Builder(builder: (context) {
                  return _buildDatePicker(() {
                    context.read<MyAppointmentCubit>().refreshForDoctor();
                  });
                }),

                const SizedBox(height: 20),

                Expanded(
                  child: BlocBuilder<MyAppointmentCubit, MyAppointmentState>(
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

                      final details = filterByDateAndStatus(state.apmDetails);

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildListHeader(details.length, (){
                              final currentCubit = context.read<MyAppointmentCubit>();
                              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                  BlocProvider.value(
                                    value: currentCubit,
                                    child: AllAppointmentsScreen(),
                                  )
                              ));
                            }),
                            const SizedBox(height: 15),
                            if (details.isNotEmpty)
                              Expanded(
                                child: ListView.separated(
                                  itemCount: details.length,
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(height: 15),
                                  itemBuilder: (context, index) {
                                    return _buildAppointmentCard(details[index], (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(detail: details[index],)));
                                    });
                                  },
                                ),
                              ),
                            if (details.isEmpty)
                              const Expanded(
                                child: Center(
                                  child: Text('Hôm nay bạn không có lịch hẹn nào'),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildDatePicker(VoidCallback refresh) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: DatePicker(
        DateTime.now().subtract(const Duration(days: 30)),
        width: 70,
        height: 90,
        controller: _datePickerController,
        initialSelectedDate: _selectedValue,
        selectionColor: const Color(0xFF4A96F5),
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 10, color: Colors.grey,
        ),
        locale: "vi_VN",
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
          });

          _datePickerController.animateToDate(date.subtract(Duration(days: 2)));

          refresh();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Chào bác sĩ,",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "Lịch hẹn hôm nay",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen())),
            icon: const Icon(Icons.notifications, color: Colors.blue, size: 22,),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListHeader(int length, VoidCallback onPressed) {
    return Row(
      children: [
        Row(
          children: [
            const Text(
              "Lịch trình",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (length > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$length',
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        const SizedBox(width: 100,),
        Expanded(
          child: TextButton.icon(
            onPressed: () => onPressed(),
            icon: Icon(Icons.calendar_month, size: 16, color: Colors.blue,),
            label: const Text("Xem tất cả lịch"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
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
                      '${detail.appointment.startAt.hour}:${detail.appointment.startAt.minute} - ${detail.appointment.endAt.hour}:${detail.appointment.endAt.minute}',
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

  List<AppointmentDetail> filterByDateAndStatus(List<AppointmentDetail> details)
  => details.where((detail) => detail.appointment.startAt.year == _selectedValue.year
      && detail.appointment.startAt.month == _selectedValue.month
      && detail.appointment.startAt.day == _selectedValue.day &&  detail.appointment.status == 'confirmed')
      .toList();
}