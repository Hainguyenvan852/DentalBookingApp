import 'package:flutter/material.dart';

class UpperBackgound extends StatelessWidget{

  const UpperBackgound({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/anhnen_nhakhoa.jpg", fit: BoxFit.cover,),
          Container(
            color: Colors.blue.withOpacity(0.55),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset("assets/images/logo_nhakhoa.png", width: 500, height: 500, ),
            ),
          ),
        ],
      ),
    );
  }
}