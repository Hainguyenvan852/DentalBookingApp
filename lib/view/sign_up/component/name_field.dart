import 'package:flutter/material.dart';

class NameField extends StatelessWidget{

  final TextEditingController nameCtrl;
  final GlobalKey<FormFieldState> nameKey;
  final ValueChanged<String> onChanged;
  const NameField({super.key, required this.nameCtrl, required this.nameKey, required this.onChanged});

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
                    child: Text('Họ và tên', style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
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
                      child: Icon(Icons.person, size: 23),
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
                          controller: nameCtrl,
                          key: nameKey,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập họ và tên"
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value){
                            if(value == null || value.isEmpty ){
                              return "Vui lòng nhập tên";
                            }
                            if(!RegExp(r'^[A-Za-zÀ-Ỹà-ỹ\s]{2,50}$').hasMatch(value)){
                              return "Họ và tên không hợp lệ";
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