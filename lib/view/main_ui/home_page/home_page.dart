import 'package:flutter/material.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repository/appointment_repository.dart';
import '../../../data/repository/user_repository.dart';
import 'component/banner_advantage.dart';
import 'component/calender_field.dart';
import 'component/feture_buttons.dart';
import 'component/navbar.dart';
import 'component/services_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final User user;
  final repo = UserRepository();
  late final AppointmentRepository apmRepo;


  @override
  void initState() {
    super.initState();
    apmRepo = AppointmentRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              const NavBar(),
              Expanded(
                child: ListView(
                  children: [
                    const BannerAdvantage(),
                    FeatureButtons(),
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

