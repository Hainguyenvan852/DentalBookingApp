import 'package:dental_booking_app/view/main_ui/notification_page/notification_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../repository/user_repository.dart';
import '../cart_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              NavBar(notifOnPressed: () => notificationOnPressed(context), cartOnPressed: () => cartOnPressed(context),),
              Expanded(
                child: ListView(
                  children: [
                    const BannerAdvantage(),
                    const FeatureButtons(),
                    const CalenderField(),
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
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => NotificationPage()
    )
  );
}

void cartOnPressed(BuildContext context){
  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CartScreen()
      )
  );
}
