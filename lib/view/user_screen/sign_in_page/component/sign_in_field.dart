import 'package:flutter/material.dart';

class SignInField extends StatefulWidget{

  final String title;
  final int obscureText;
  final TextEditingController textEditingController;

  const SignInField({super.key, required this.title, required this.obscureText, required this.textEditingController});

  @override
  State<StatefulWidget> createState() {
    return SignInFieldState();
  }
}

class SignInFieldState extends State<SignInField>{

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.title, style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: SizedBox(
              height:55,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 15),
                    child: Icon(widget.obscureText == 0 ? Icons.phone : Icons.lock, size: 23, color: Colors.grey,),
                  ),
                  Container(
                    height: 23,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextField(
                        controller: widget.textEditingController,
                        obscureText: (widget.obscureText == 0 ? false : true),
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}