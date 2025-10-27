import 'package:dental_booking_app/view/main_ui/service_page/general_examination_page.dart';
import 'package:dental_booking_app/view/main_ui/service_page/implant_page.dart';
import 'package:dental_booking_app/view/main_ui/service_page/orthodontics_page.dart';
import 'package:dental_booking_app/view/main_ui/service_page/porcelain_teeth_page.dart';
import 'package:flutter/material.dart';

class ServicesBox extends StatelessWidget {
  const ServicesBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      padding: EdgeInsets.only(top: 15, right: 8, left: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('Trải nghiệm dịch vụ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
          ),
          Card(
            color: Colors.white,
            elevation: 5,
            child: Column(
              children: [
                ServiceField(img: 'assets/images/implant.png', name: 'Implant', desscription: 'Phục hình răng hàm', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ImplantServicePage()));
                },),
                ServiceField(img: 'assets/images/niengrang.png', name: 'Chỉnh nha', desscription: 'Niềng răng phục hình', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> OrthodonticsPage()));
                },),
                ServiceField(img: 'assets/images/phuchinh.png', name: 'Phục hình', desscription: 'Bọc răng sứ thẩm mỹ', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PorcelainTeethPage()));
                },),
                ServiceField(img: 'assets/images/khamtongquat.png', name: 'Tổng quát', desscription: 'Tư vấn và khám tổng quát', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> GeneralExamPage()));
                },),
              ],
            ),
          )
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
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10,),
            height: 70,
            width: 295,
            child: Row(
              children: [
                Image.asset(img, width: 60, height: 60, fit: BoxFit.cover,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                    Text(desscription, style: TextStyle(fontSize: 13))
                  ],
                )
              ],
            ),
          ),
          Expanded(child: IconButton(onPressed: ()=> onPressed(), icon: Icon(Icons.keyboard_arrow_right)))
        ],
      ),
    );
  }
}
