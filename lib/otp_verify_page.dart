import 'package:flutter/material.dart';

class OtpVerifyPage extends StatelessWidget{

  final String email;

  const OtpVerifyPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(left: 55.0),
          child: Text("Mã xác thực OTP", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
        ),
        shape: UnderlineInputBorder(borderSide: BorderSide(width: 0.8)),
      ),
      body: Container(
        height: 150,
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text("Điền mã OTP vừa được gửi tới email:", style: TextStyle(fontSize: 19, color: Colors.black45),),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(email,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
          ],
        )
      ),
    );
  }
}