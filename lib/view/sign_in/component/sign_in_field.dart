import 'package:dental_booking_app/res/constants.dart';
import 'package:flutter/material.dart';

class SignInField extends StatefulWidget{

  final String title;
  final int obscureText;

  const SignInField({super.key, required this.title, required this.obscureText});

  @override
  State<StatefulWidget> createState() {
    return SignInFieldState();
  }
}

class SignInFieldState extends State<SignInField>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: SizedBox(
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: defaultPadding/5*2),
              child: Text(widget.title, style: TextStyle(fontSize: 20,), textAlign: TextAlign.start,),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding/5*2, right:defaultPadding/4*3),
                      child: Icon(widget.obscureText == 0 ? Icons.phone : Icons.lock, size: 30, color: Colors.grey,),
                    ),
                    // Divider(thickness: 2, height: 5, color: Colors.black,),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          obscureText: (widget.obscureText == 0 ? false : true),
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}