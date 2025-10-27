import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../logic/date_cubit.dart';



class DateField extends StatefulWidget {
  const DateField({super.key,});

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final dateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateCtrl.text = DateFormat('EE, dd/MM/yyyy', 'vi_VN').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final dateCubit = context.read<DateCubit>();

    return BlocBuilder<DateCubit, DateState>(
      builder: (context, st){
        return SizedBox(
          height: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: TextSpan(
                  text: 'Ngày hẹn',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                  children: [
                    TextSpan(text: '  *', style: TextStyle(color: Colors.red))
                  ]
              ),
              ),
              Container(
                height: 43,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(219, 217, 217, 1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 5, ),
                  child: TextFormField(
                    readOnly: true,
                    controller: dateCtrl,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 5),
                        icon: Icon(Icons.calendar_month, size: 19, color: Colors.grey,)
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final DateTime? selectedDate = await showDatePicker(
                        locale: const Locale('vi', 'VN'),
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2027),
                      );

                      if (selectedDate != null){
                        dateCtrl.text = DateFormat('EE, dd/MM/yyyy', 'vi_VN').format(selectedDate);
                        dateCubit.select(selectedDate);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}