import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RescheduleScreen extends StatefulWidget {
  const RescheduleScreen({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  final List<String> _timeSlots = [
    "7:30 - 8:30",
    "8:30 - 9:30",
    "9:30 - 10:30",
    "10:30 - 11:30"
  ];

  String _selectedTime = "";
  DateTime _selectedDate = DateTime.now();
  int _slideDirection = 0;
  bool canSubmit = false;
  
  void _changeDate(int days) {
    setState(() {
      _slideDirection = days.sign;
      _selectedDate = _selectedDate.add(Duration(days: days));
      _selectedTime = '';
      canSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Đổi khung thời gian", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn khung thời gian bạn muốn thay đổi?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Chọn ngày và giờ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildDateSelector(),
            const SizedBox(height: 30),

            _buildTimeSelector(),

            const Spacer(),

            _buildContinueButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final String formattedDate = DateFormat('EEEE, dd MMMM, yyyy', 'vi_VN').format(_selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _changeDate(-1),
              icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black54)
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {

                final isIncoming = (child.key == ValueKey(_selectedDate));
                final Tween<Offset> slideTween;

                if (isIncoming) {
                  slideTween = Tween<Offset>(
                    begin: Offset(_slideDirection.toDouble(), 0.0),
                    end: Offset.zero,
                  );
                } else {
                  slideTween = Tween<Offset>(
                    begin: Offset(-_slideDirection.toDouble(), 0.0),
                    end: Offset.zero,
                  );
                }

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideTween.animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                key: ValueKey(_selectedDate),
                formattedDate,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => _changeDate(1),
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _timeSlots.map((time) {
          final isSelected = time == _selectedTime;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                  if(!canSubmit){
                    canSubmit = true;
                  }
                });
              },
              child: _buildTimeChip(time, isSelected),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit ? (){} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Continue",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}