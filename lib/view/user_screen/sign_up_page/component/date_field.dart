import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget{
  final TextEditingController dateController;
  const DatePickerField({super.key, required this.dateController, });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
        locale: const Locale('vi', 'VN'),
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (selectedDate != null){
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 0),
        child: SizedBox(
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text("Ngày sinh", style: TextStyle(fontSize: 16,), textAlign: TextAlign.start,),
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
                        child: Icon(Icons.date_range, size: 23),
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
                                controller: dateController,
                                readOnly: true,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Chọn ngày sinh',
                                  border: InputBorder.none,
                                ),
                                onTap: (){
                                  debugPrint(Localizations.localeOf(context).toString());
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _selectDate(context);
                                }
                            )
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

