import 'package:flutter/material.dart';

class LogUpButton extends StatelessWidget {

  bool enable;
  final VoidCallback onPressed;

  LogUpButton({super.key, required this.enable, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
          onPressed: enable ? onPressed : null,
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
              backgroundColor: Colors.lightBlue,
              disabledBackgroundColor: Colors.grey,
              foregroundColor: Colors.white
          ),
          child: Text("Đăng ký", style: TextStyle(fontSize: 20,),)
      ),
    );
  }
}