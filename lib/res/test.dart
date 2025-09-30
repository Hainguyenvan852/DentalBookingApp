import 'dart:async';

import 'package:dental_booking_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_options.dart';
import '../view/sign_in/bloc/auth_cubit.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  FirebaseFirestore db = FirebaseFirestore.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Page',
      home: const MainUI(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainUI extends StatefulWidget{

  const MainUI({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainUIState();
  }
}

class _MainUIState extends State<MainUI>{

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Quay lại đăng nhập',
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () async {
            await context.read<AuthCubit>().signOut();
            if (!mounted) return;
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil('/signin', (r) => false);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const Text(
                'Xác thực email của bạn',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 320,
                child: Text(
                  'Kiểm tra hộp thư và nhấn vào liên kết để xác minh tài khoản.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 70),
              Image.asset('assets/images/email-send-2.png', width: 220),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Nếu cần: mở app email, deep link mailto:, v.v.
                  context.read<AuthCubit>().signOut();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.blue
                ),
                child: const Text('MỞ ỨNG DỤNG EMAIL', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  try {
                    await user?.sendEmailVerification();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã gửi lại email xác minh.')),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi gửi email: $e')),
                    );
                  }
                },
                child: const Text('Gửi lại email', style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}




