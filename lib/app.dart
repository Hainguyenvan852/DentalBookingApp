import 'package:dental_booking_app/view/doctor_screen/screens/admin_dashboard.dart';
import 'package:dental_booking_app/view/user_screen/navigation_page.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_gate.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/sign_in_screen.dart';
import 'package:dental_booking_app/view/user_screen/sign_up_page/sign_up_screen.dart';
import 'package:dental_booking_app/view/user_screen/sign_up_page/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: NoStretchBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),

      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AuthGate(),
      routes: {
        '/signin' : (_) => const SignInPage(),
        '/signup' : (_) => const SignUpPage(),
        '/patient_home' : (_) => const NavigationPage(),
        '/verify' : (_) => const VerifyEmailPage(),
        '/admin_home': (_) => const DashboardScreen()
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