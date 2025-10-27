import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/dentist_cubit.dart';

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
                RichText(text: TextSpan(
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

                        return DoctorComponent(name: d.name, selected: selected, onTap: () {_selectChange(d.id); context.read<DentistCubit>().select(d);},);
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
  DoctorComponent({super.key, required this.name, required this.selected, required this.onTap});
  final String name;
  bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: selected ? Colors.green : Colors.white)
        ),
        width: 80,
        child: Column(
          children: [
            SizedBox(height: 5,),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  color: Colors.blue,
                  height: 55,
                  child: Image.network('https://yeudialy.edu.vn/upload/2025/05/chibi-bac-si13.webp', width: 55,)//SvgPicture.asset('assets/icons/user_outline.svg', width: 55,)
              ),
            ),
            SizedBox(height: 7,),
            Text(name, style: TextStyle(fontSize: 13), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}