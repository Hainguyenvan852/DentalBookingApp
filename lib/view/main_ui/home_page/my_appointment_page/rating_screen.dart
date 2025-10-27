import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:dental_booking_app/data/repository/appointment_repository.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key, required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: double.infinity,
      height: 330,
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -15,
            child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.cancel, size: 22, color: Colors.red,))),
          Column(
            children: [
              Text('Đánh giá của bạn',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              RatingBox(appointment: appointment,),
            ],
          ),
        ],
      )
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<RatingBox> createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int rating = 0;
  final _contrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      rating = 1;
                    });
                  },
                  child: Image.asset('assets/icons/star-2.png',  fit: BoxFit.cover, height: 35, color: rating >= 1 ? Colors.yellow : Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      rating = 2;
                    });
                  },
                  child: Image.asset('assets/icons/star-2.png',  fit: BoxFit.cover, height: 35, color: rating >= 2 ? Colors.yellow : Colors.grey,)
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      rating = 3;
                    });
                  },
                  child: Image.asset('assets/icons/star-2.png',  fit: BoxFit.cover, height: 35, color: rating >= 3 ? Colors.yellow : Colors.grey,)
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      rating = 4;
                    });
                  },
                  child: Image.asset('assets/icons/star-2.png',  fit: BoxFit.cover, height: 35, color: rating >= 4 ? Colors.yellow : Colors.grey,)
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      rating = 5;
                    });
                  },
                  child: Image.asset('assets/icons/star-2.png',  fit: BoxFit.cover, height: 35, color: rating == 5 ? Colors.yellow : Colors.grey,)
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          Text('Nội dung đánh giá',),
          SizedBox(height: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextFormField(
                controller: _contrl,
                maxLines: 10,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, top: 5)
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          if (widget.appointment.rating == 0)
            ElevatedButton(
                onPressed: rating != 0 ? () async {
                  Appointment apm;
                  if(_contrl.text.isNotEmpty){
                     apm = widget.appointment.copyWith(rating: rating, content: _contrl.text);
                  }
                  else{
                     apm = widget.appointment.copyWith(rating: rating);
                  }
                  final result = await AppointmentRepository().update(apm);
                  Navigator.pop(context, true);

                  if(result == 'success'){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã gửi')));
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $result')));
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(260, 45),
                    maximumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green
                ),
                child: Text('Gửi đánh giá')
            ),
          if(widget.appointment.rating > 0)
            Text('Da danh gia')
        ],
      ),
    );
  }
}

