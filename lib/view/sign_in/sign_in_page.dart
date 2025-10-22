import 'package:dental_booking_app/view/sign_in/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_state.dart';
import 'component/sign_in_body.dart';
import 'component/upper_background.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key,});

  @override
  Widget build(BuildContext context) {

    var deviceSize = MediaQuery.sizeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 116, 189, 248),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state){
            if(state is AuthUnauthenticated && state.message != null){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                    backgroundColor: Colors.black38,
                  ),
                );
              });
            }
            return Stack(
              children:
                [
                  Column(
                    children: [
                      UpperBackground(deviceSize: deviceSize,),
                      Expanded(
                          child: SignInBody()
                      ),
                    ],
                  ),

                ],
            );
          },
        ),
    );
  }
}

