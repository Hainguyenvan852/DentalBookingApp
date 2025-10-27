import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/clinic_model.dart';
import '../../../../logic/slot_cubit.dart';

class TimeSlotSelections extends StatefulWidget {
  const TimeSlotSelections({super.key});


  @override
  State<TimeSlotSelections> createState() => _TimeSlotSelectionsState();
}

class _TimeSlotSelectionsState extends State<TimeSlotSelections> {

  String _selectedTime = "";

  @override
  void initState() {
    super.initState();
  }

  void _selectChange(String id){
    if (_selectedTime == id){
      return;
    }
    setState(() {
      _selectedTime = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSlotCubit, TimeSlotState>(
        builder: (context, st){
          if (!st.ready) return const Text('Chọn chi nhánh và ngày để xem khung giờ');
          return SizedBox(
              height: 140,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: TextSpan(
                        text: 'Khung giờ',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15 ),
                        children: [TextSpan(text: '  *', style: TextStyle(color: Colors.red))])
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, mainAxisExtent: 130),
                        itemBuilder: (context, index) {
                          final c = st.slots[index];
                          final selected = c.id == _selectedTime;

                          final status = st.statusBySlotId[c.id];
                          final color = switch(status){
                            SlotStatus.crowded => Colors.red,
                            SlotStatus.normal => Colors.green,
                            SlotStatus.empty => Colors.grey,
                            SlotStatus.closed => Colors.black12,
                            SlotStatus.userBooked => Colors.blue,
                            _ => Colors.grey,
                          };

                          return TimeBox(slot: c, selected: selected,
                            onTap: () {
                              _selectChange(c.id);
                              context.read<TimeSlotCubit>().select(c);
                            },
                            color: color, status: status,);
                        },
                        itemCount: st.slots.length,
                      )
                    )
                  ]
              )
          );
        }
    );
  }
}

class TimeBox extends StatelessWidget {

  TimeBox({super.key, required this.slot, required this.selected, required this.onTap, required this.color, required this.status});

  final VoidCallback onTap;

  final TimeSlot slot;
  final Color color;
  final SlotStatus? status;
  final bool selected;

  String getStatus(SlotStatus s){
    final status = switch(s){
      SlotStatus.crowded => 'Đông',
      SlotStatus.normal => 'Bình thường',
      SlotStatus.empty => 'Vắng',
      SlotStatus.closed => 'Đóng',
      SlotStatus.userBooked => 'Đã có lịch',
      _ => 'Vắng',
    };

    return status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => status == SlotStatus.userBooked ? null : onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
          color: selected ? Colors.greenAccent : Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(slot.id, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
            Text(getStatus(status!), style: TextStyle(fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color)
            )
          ],
        ),
      )
    );
  }
}

