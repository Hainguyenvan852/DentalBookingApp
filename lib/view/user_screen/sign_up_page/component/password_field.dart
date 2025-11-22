import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget{

  final TextEditingController passwordCtrl;
  final GlobalKey<FormFieldState> passwordKey;
  final ValueChanged<String> onChanged;
  const PasswordField({super.key, required this.passwordCtrl, required this.passwordKey, required this.onChanged});

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
                    child: Text('Mật khẩu', style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
                  ),
                  Text('*',
                    style: TextStyle(fontSize: 20, color: Colors.red, ),
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
                          key: passwordKey,
                          controller: passwordCtrl,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập mật khẩu"
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value){
                            if(value == null || value.isEmpty ){
                              return "Vui lòng nhập mật khẩu";
                            }
                            if(!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,16}$').hasMatch(value)){
                              return "Cần ít nhất 8 kí tự, 1 kí tự đặc biệt, 1 kí tự viết hoa và 1 số";
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