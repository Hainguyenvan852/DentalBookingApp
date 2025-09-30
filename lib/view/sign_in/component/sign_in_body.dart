import 'package:dental_booking_app/res/constants.dart';
import 'package:dental_booking_app/view/sign_in/bloc/auth_cubit.dart';
import 'package:dental_booking_app/view/sign_in/component/sign_in_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sign_up/sign_up_page.dart';

class SignInBody extends StatefulWidget{

  SignInBody({super.key, });

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {

  final accountCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    accountCtrl.addListener(_checkFormValid);
    passwordCtrl.addListener(_checkFormValid);
  }

  void _checkFormValid(){
    bool isValid = accountCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty;

    setState(() {
      _canSubmit = isValid;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white),
      clipBehavior: Clip.antiAlias,// Bắt buộc widget con bị cắt theo BorderRadius
      child:SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 30),
              child: Center(
                child: Text("Đăng nhập", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              ),
            ),
            SignInField(title: "Tài khoản", obscureText: 0, textEditingController: accountCtrl,),
            SignInField(title: "Mật khẩu", obscureText: 1, textEditingController: passwordCtrl,),
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding, right: defaultPadding/2, left: defaultPadding/2),
              child: ElevatedButton(
                  onPressed: (!_canSubmit) ? null : () async{
                    if(_canSubmit){
                      context.read<AuthCubit>().signIn(accountCtrl.text.trim(), passwordCtrl.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child:Text("Đăng nhập", style: TextStyle(fontSize: 16),)
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn đăng ký tài khoản chưa?",
                    style: TextStyle(fontSize: 15),),
                  TextButton(
                    onPressed:() => registerClick(context),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.orange,
                        padding: EdgeInsets.only(left: 3)
                    ),
                    child: Text("Đăng ký ngay", style: TextStyle(fontSize: 15)),),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  void registerClick(BuildContext context) {
    // Navigator.pushNamed(context, '/signup');
    context.read<AuthCubit>().requestSignUp();
  }
}