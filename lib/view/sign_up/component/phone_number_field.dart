import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget{

  final TextEditingController phoneCtrl;
  final GlobalKey<FormFieldState> phoneKey;
  final ValueChanged<String> onChanged;
  const PhoneNumberField({super.key, required this.phoneCtrl, required this.phoneKey, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
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
                    child: Text('Số điện thoại', style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
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
                height: 50, // Chỉnh sửa kích thước của Container
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
                          key: phoneKey,
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập số điện thoại"
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value){
                            if(value == null || value!.isEmpty ){
                              return "Vui lòng nhập số điện thoại";
                            }
                            if(!RegExp(r'^(?:\+84|0)(?:\d{9})$').hasMatch(value)){
                              return "Số điện thoại không hợp lệ";
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