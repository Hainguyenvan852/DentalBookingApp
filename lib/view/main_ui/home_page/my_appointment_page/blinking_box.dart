import 'package:flutter/material.dart';

import '../../../../data/model/appointment_model.dart';

class BlinkingContainer extends StatefulWidget {
  const BlinkingContainer({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<BlinkingContainer> createState() => _BlinkingContainerState();
}

class _BlinkingContainerState extends State<BlinkingContainer> with SingleTickerProviderStateMixin{

  late final AnimationController _animationController = AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        height: 30,
        width: 70,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(child: Text('Đã duyệt', style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}

class AppointmentStateBox extends StatelessWidget {
  const AppointmentStateBox({super.key, required this.appointment});
  final Appointment appointment;

  String getState(){
    final status = switch(appointment.status){
      'confirmed' => 'Đã duyệt',
      'pending' => 'Chưa duyệt',
      'completed' => 'Kết thúc',
      'canceled' => 'Đã hủy',
      _ => 'Chưa duyệt'
    };

    return status;
  }

  Color getColorWithState(){
    final color = switch(appointment.status){
      'pending' => Colors.grey,
      'completed' => Colors.red,
      'canceled' => Colors.red,
      _ => Colors.red,
    };

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: getColorWithState(),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Center(child: Text(getState(), style: TextStyle(color: Colors.white, fontSize: 12),)),
    );
  }
}