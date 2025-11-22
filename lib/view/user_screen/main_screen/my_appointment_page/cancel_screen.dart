import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/appointment_detail_cubit.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key, required this.apm});
  final Appointment apm;

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;

  final List<String> _reasons = [
    "Tôi không còn nhu cầu sử dụng dịch vụ.",
    "Tôi muốn thay đổi thông tin đặt lịch.",
    "Tôi có việc bận đột xuất.",
    "Giá quá cao / Chi phí phát sinh.",
    "Gặp vấn đề về di chuyển.",
    "Tôi không hài lòng với đánh giá/thông tin về dịch vụ.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 19),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tại sao bạn muốn hủy lịch hẹn này?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: _reasons.map((reason) {
                  return _buildReasonTile(reason);
                }).toList(),
              ),
              const SizedBox(height: 30,),
              Center(
                child: ElevatedButton(
                    onPressed: _selectedReason!= null ? (){
                      final cancelApm = widget.apm.copyWith(status: 'canceled_by_patient', canceledAt: DateTime.now(), cancelReason: _selectedReason);
                      context.read<AppointmentDetailCubit>().cancel(cancelApm);
                      Navigator.pop(context);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      maximumSize: Size(double.infinity, 55),
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                        'Xác nhận',
                      style: TextStyle(fontSize: 18),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonTile(String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReason = reason;
          });
        },
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: reason,
                groupValue: _selectedReason,
                onChanged: (String? value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                activeColor: Colors.red,
              ),
              Flexible(
                child: Text(
                  reason,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}