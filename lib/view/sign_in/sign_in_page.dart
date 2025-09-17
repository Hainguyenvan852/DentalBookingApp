import 'package:flutter/material.dart';
import 'component/sign_in_body.dart';
import 'component/upper_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(titleMedium: TextStyle(fontSize: 16, ))
      ),
      home: const LoginPage(title: 'Dental Booking App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {

    var deviceSize = MediaQuery.sizeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 116, 189, 248),
        body: Column(
          children: [
            UpperBackground(deviceSize: deviceSize,),
            Expanded(
                child: SignInBody()
            ),
          ],
        )
    );
  }
}

