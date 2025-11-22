import 'dart:async';
import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  Timer? _timer;
  bool _handled = false;
  int _ticks = 0;

  @override void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      _ticks++;
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final verified = user?.emailVerified ?? false;
      if (!_handled && verified) {
        _handled = true;
        _timer?.cancel();
        if (!mounted) return;
        showDialog( context: context, useRootNavigator: true,
          builder: (dialogContext) {
            return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Center(
                  child: const Text( 'XÁC MINH EMAIL THÀNH CÔNG', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.green), ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Image.asset('assets/images/email-success-2.png', width: 80),
                    const SizedBox(height: 10),
                    const Text( 'Tài khoản của bạn đã được xác minh.\nVui lòng đăng nhập để tiếp tục.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.green),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                        await context.read<AuthCubit>().checkEmailVerified();
                        // Navigator.pushNamedAndRemoveUntil(dialogContext, '/home', (predict) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 30),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) )
                      ),
                      child: const Text('Đồng ý', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
            );
          },
        );
      } else if
      (!verified && _ticks >= 40) {
        _timer?.cancel();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Chưa xác minh. Kiểm tra email hoặc bấm Gửi lại.')),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
