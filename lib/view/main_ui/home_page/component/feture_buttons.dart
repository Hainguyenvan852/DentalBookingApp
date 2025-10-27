import 'package:dental_booking_app/view/main_ui/home_page/my_appointment_page/my_appointment_page.dart';
import 'package:dental_booking_app/view/main_ui/product_catalog_page/product_catalog_page.dart';
import 'package:dental_booking_app/view/main_ui/service_page/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../booking_page/booking_page.dart';
import '../../gallery_page/gallery_page.dart';

class FeatureButtons extends StatelessWidget {
  const FeatureButtons({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      padding: EdgeInsets.only(top: 12, left: 8, right: 8),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 30,
        crossAxisCount: 3,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(initService: null,)));
                },
                icon: SvgPicture.asset('assets/icons/calendar.svg', width: 20,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Đặt lịch', style: TextStyle(fontSize: 13),)
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppointmentPage()));
                },
                icon: SvgPicture.asset('assets/icons/clock.svg', color: Colors.blue,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Lịch hẹn của\ntôi',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPage()));
                },
                icon: SvgPicture.asset('assets/icons/picture.svg', width: 20,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Ảnh điều trị', style: TextStyle(fontSize: 13),)
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductCatalogPage()));
                },
                icon: SvgPicture.asset('assets/icons/toothbrush.svg', width: 22,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Sản phẩm',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage()));
                },
                icon: SvgPicture.asset('assets/icons/catalog.svg', width: 24),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Danh mục\ndịch vụ',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.message, color: Colors.blue,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Liên hệ',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      )
    );
  }
}
