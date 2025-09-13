import 'package:dental_booking_app/res/constants.dart';
import 'package:dental_booking_app/view/sign_in/component/sign_in_field.dart';
import 'package:flutter/material.dart';

import '../../sign_up/sign_up_page.dart';

class SignInBody extends StatelessWidget{
  const SignInBody({super.key});

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
                child: Text("Đăng nhập", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              ),
            ),
            SignInField(title: "Tài khoản", obscureText: 0),
            SignInField(title: "Mật khẩu", obscureText: 1),
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding, right: defaultPadding/5, left: defaultPadding/5),
              child: ElevatedButton(
                  onPressed: () => loginClick(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(390, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text("Đăng nhập", style: TextStyle(fontSize: 20),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn đã đăng ký tài khoản chưa?",
                    style: TextStyle(fontSize: 16),),
                  TextButton(
                    onPressed: () => registerClick(context),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.orange
                    ),
                    child: Text("Đăng ký ngay", style: TextStyle(fontSize: 16)),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void loginClick(BuildContext context) {

  }

  void registerClick(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => RegisterPage()
        )
    );
  }
}