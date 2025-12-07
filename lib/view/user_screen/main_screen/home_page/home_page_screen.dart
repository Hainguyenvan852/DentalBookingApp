import 'package:dental_booking_app/logic/notification_cubit.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/cart_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/notification_page/notification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../data/model/appointment_model.dart';
import '../../../../data/model/user_model.dart';
import '../../../../data/repository/appointment_repository.dart';
import '../../../../data/repository/notification_repository.dart';
import '../../../../data/repository/user_repository.dart';
import 'component/banner_advantage.dart';
import 'component/calender_field.dart';
import 'component/feture_buttons.dart';
import 'component/services_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserModel user;
  final _auth = FirebaseAuth.instance;
  final _userRepo = UserRepository();
  final _notificationRepo = NotificationRepository();
  final _appointmentRepo = AppointmentRepository();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 300,
        leading: Container(
            padding: EdgeInsets.only(left: 8, top: 8),
            height: 55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: _userRepo.getUser(_auth.currentUser!.uid),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                              constraints: BoxConstraints(
                                  minHeight: 18,
                                  minWidth: 18
                              ),
                            )
                        );
                      }

                      final user = snapshot.data!;

                      return Text('Xin chào ${user.fullName}', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),);
                    }
                ),
                const SizedBox(height: 4),
                FutureBuilder(
                  future: _appointmentRepo.getTodayAppointment(_auth.currentUser!.uid),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            constraints: BoxConstraints(
                                minHeight: 12,
                                minWidth: 12
                            ),
                          )
                      );
                    }
                
                    final List<Appointment> appointments = snapshot.data ?? [];
                
                    if(appointments.isEmpty){
                      return Text('Hôm nay bạn không có lịch hẹn',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          )
                      );
                    }
                    else {
                      return Text('Hôm nay bạn có ${appointments.length} lịch hẹn',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          )
                      );
                    }
                  },
                )
              ],
            )
        ),
        actions: [
          RepositoryProvider(
            create: (context) => _notificationRepo,
            child: BlocProvider(
              create: (context) => NotificationCubit()..load(),
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () => notificationOnPressed(context),
                    icon: state.haveUnread ? SvgPicture.asset('assets/icons/notification-new.svg', width: 20,)
                      : SvgPicture.asset('assets/icons/notification.svg', width: 20,)
                  );
                }
              )
            ),
          ),
          IconButton(onPressed: () => cartOnPressed(context), icon: SvgPicture.asset('assets/icons/shopping-cart.svg', width: 20,))
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const BannerAdvantage(),
                    FeatureButtons(),
                    const SizedBox(height: 20,),
                    CalenderField(),
                    const ServicesBox(),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

void notificationOnPressed(BuildContext context){
  final cubit = context.read<NotificationCubit>();

  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit, 
            child: NotificationPage(),
          )
      )
  );
}

void cartOnPressed(BuildContext context){
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ShoppingCartScreen())
    );
}