import 'package:dental_booking_app/view/main_ui/navigation_page.dart';
import 'package:dental_booking_app/view/sign_in/bloc/auth_gate.dart';
import 'package:dental_booking_app/view/sign_in/sign_in_page.dart';
import 'package:dental_booking_app/view/sign_up/sign_up_page.dart';
import 'package:dental_booking_app/view/sign_up/verify_email.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: NoStretchBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AuthGate(),
      routes: {
        '/signin' : (_) => const SignInPage(),
        '/signup' : (_) => const SignUpPage(),
        '/home' : (_) => const NavigationPage(),
        '/verify' : (_) => const VerifyEmailPage()
      },
    );
  }
}

class NoStretchBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}