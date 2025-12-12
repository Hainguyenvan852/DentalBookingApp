import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/product_catalog_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/service_page/service_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/support_page/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../booking_page/booking_screen.dart';
import '../../gallery_page/gallery_screen.dart';
import '../../my_appointment_page/my_appointment_page.dart';

class FeatureButtons extends StatelessWidget {
  const FeatureButtons({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
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
              Text('Đặt lịch', style: TextStyle(fontSize: 14),)
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
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPage()),);
                },
                icon: SvgPicture.asset('assets/icons/picture.svg', width: 20,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.lightBlue[50]
                ),
              ),
              Text('Ảnh điều trị', style: TextStyle(fontSize: 14),)
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
                style: TextStyle(fontSize: 14),
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
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportScreen())),
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
