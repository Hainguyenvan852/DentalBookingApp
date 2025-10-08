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
        title: Text('Dịch vụ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ServiceField(img: 'assets/images/implant.png', name: 'Implant', desscription: 'Phục hình răng hàm', onPressed: () {  },),
          ServiceField(img: 'assets/images/niengrang.png', name: 'Chỉnh nha', desscription: 'Niềng răng phục hình', onPressed: () {  },),
          ServiceField(img: 'assets/images/phuchinh.png', name: 'Phục hình', desscription: 'Bọc răng sứ thẩm mỹ', onPressed: () {  },),
          ServiceField(img: 'assets/images/khamtongquat.png', name: 'Tổng quát', desscription: 'Tư vấn và khám tổng quát', onPressed: () {  },),
          TextButton(onPressed: _authRepo.signOut, child: Text('dang xuat'))
        ],
      ),
    );
  }
}

class ServiceField extends StatelessWidget {

  final String img, name, desscription;
  final VoidCallback onPressed;

  const ServiceField({super.key, required this.img, required this.name, required this.desscription, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Image.asset(img, width: 65, height: 65, fit: BoxFit.cover,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                      Text(desscription, style: TextStyle(fontSize: 12))
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