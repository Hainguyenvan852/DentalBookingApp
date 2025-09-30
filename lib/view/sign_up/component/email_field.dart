import 'package:flutter/material.dart';

class EmailField extends StatelessWidget{

  final TextEditingController emailCtrl;
  final GlobalKey<FormFieldState> emailKey;
  final ValueChanged<String> onChanged;
  const EmailField({super.key, required this.emailCtrl, required this.emailKey, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
      child: SizedBox(
        height: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text('Email', style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
                  ),
                  Text('*',
                    style: TextStyle(fontSize: 16, color: Colors.red, ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right:15),
                      child: Icon(Icons.call, size: 23),
                    ),
                    Container(
                      height: 28,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: emailKey,
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập email"
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value){
                            if(value == null || value.isEmpty ){
                              return "Vui lòng nhập email";
                            }
                            if(!RegExp(r'^\w+@gmail\.com').hasMatch(value)){
                              return "Email không hợp lệ";
                            }
                            return null;
                          },
                          onChanged: (v){
                            onChanged(v);
                          },
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