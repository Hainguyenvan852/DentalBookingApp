import 'package:dental_booking_app/data/model/dentist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../logic/dentist_cubit.dart';

class DentistSelection extends StatefulWidget {
  const DentistSelection({super.key,});

  @override
  State<DentistSelection> createState() => _DentistSelectionState();
}

class _DentistSelectionState extends State<DentistSelection> {

  String? _selectedId;

  void _selectChange(String id){
    if(_selectedId == id){
      return;
    }

    setState(() {
      _selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DentistCubit, DentistState>(
        builder: (context, st){
          return SizedBox(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Bác sĩ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                    children: [
                      TextSpan(text: '  *', style: TextStyle(color: Colors.red))
                    ]
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final d = st.dentists[index];
                        final selected = d.id == _selectedId;

                        return DoctorComponent(dentist: d, selected: selected, onTap: () {_selectChange(d.id); context.read<DentistCubit>().select(d);},);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 10);
                      },
                      itemCount: st.dentists.length,
                    )
                )
              ],
            ),
          );
        }
    );
  }
}



class DoctorComponent extends StatelessWidget {
  DoctorComponent({super.key, required this.dentist, required this.selected, required this.onTap});
  final Dentist dentist;
  bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: selected ? Colors.blue : Colors.white24)
        ),
        width: 80,
        child: Column(
          children: [
            SizedBox(height: 5,),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  color: Colors.blue.shade200,
                  height: 55,
                  child: dentist.sex ? Image.asset('assets/images/men_doctor.png', width: 55,) : Image.asset('assets/images/women_doctor.png', width: 55,)
              ),
            ),
            SizedBox(height: 7,),
            Text(dentist.name, style: TextStyle(fontSize: 13), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}