import 'package:flutter/material.dart';

class BranchSelectionField extends StatelessWidget{

  final String? value;
  final ValueChanged<String?> onChanged;

  const BranchSelectionField({super.key, this.value, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
      child: SizedBox(
        height: 100,
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0,),
                    child: Text("Chi nhánh", style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
                  ),
                  Text('*',
                    style: TextStyle(fontSize: 16, color: Colors.red, ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right:15),
                      child: Icon(Icons.location_on,size: 23,),
                    ),
                    Container(
                      height: 28,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: DropdownButtonFormField(
                            value: value,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "Chọn chi nhánh",
                                border: InputBorder.none,
                            ),
                            items: ['Chi nhánh Cầu Giấy', 'Chi nhánh Xuân Thủy', 'Chi nhánh Đống Đa'].map((item){
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: TextStyle(fontSize: 16),));
                            }).toList(),
                            onChanged: (value){
                              onChanged(value);
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Vui lòng chọn chi nhánh';
                              }
                              return null;
                            },
                          )
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


