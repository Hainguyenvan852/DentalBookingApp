import 'package:dental_booking_app/view/user_screen/sign_up_page/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation_page.dart';
import '../../sign_up_page/verify_email_screen.dart';
import '../component/splash_screen.dart';
import '../sign_in_screen.dart';

import 'auth_cubit.dart';
import 'auth_state.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (p, c) => p.runtimeType != c.runtimeType,
        builder: (context, state) {
          if (state is AuthUnknown) return const SplashPage();
          if(state is AuthLoading) {
            return Scaffold(
            body:
              Center(
                child: const CircularProgressIndicator(
                  color: Colors.lightBlueAccent,
                ),
              ),
            );
          }
          if (state is AuthRequestSignUp) return SignUpPage();
          if (state is AuthUnauthenticated) return const SignInPage();
          if (state is AuthNeedsEmailVerify) return const VerifyEmailPage();
          if (state is AuthAuthenticated) return const NavigationPage();
          return const SignInPage();
        },
    );
  }
}
