import 'package:dental_booking_app/view/main_ui/booking_page/booking_page.dart';
import 'package:dental_booking_app/view/model/service_model.dart';
import 'package:dental_booking_app/view/repository/service_repository.dart';
import 'package:flutter/material.dart';

import '../../../service/authentication_repository.dart';

class ServicePage extends StatelessWidget {
  ServicePage({super.key});

  final _authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.grey)
        ),
        backgroundColor: Colors.white,
        title: Text('Dịch vụ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: ServiceRepository().getAll(),
          builder: (context, snap){
            if (snap.connectionState == ConnectionState.waiting){
              return Center(child: LinearProgressIndicator(),);
            }
            final services = snap.data;
            if (services == null){
              return Text("Khong co du lieu");
            }
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index){
                return ServiceField(service: services[index], onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(initService: services[index])));
                });
              }
            );
          }
      )
    );
  }
}

class ServiceField extends StatelessWidget {

  final Service service;
  final VoidCallback onPressed;

  const ServiceField({super.key, required this.onPressed, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10,),
              height: 80,
              width: 250,
              child: Row(
                children: [
                  Image.network(service.imageUrl, width: 65, height: 65, fit: BoxFit.cover,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(service.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                      Text(service.description, style: TextStyle(fontSize: 12))
                    ],
                  )
                ],
              ),
            ),
            OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    side: BorderSide(
                        color: Colors.blue
                    ),
                    minimumSize: Size(55,28),
                    maximumSize: Size(70, 35),
                    padding: EdgeInsets.only()
                ),
                child: Text('Đặt lịch', style: TextStyle(fontSize: 10, color: Colors.blue),)
            )
          ],
        ),
      ),
    );
  }
}