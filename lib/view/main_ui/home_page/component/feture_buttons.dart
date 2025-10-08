import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatureButtons extends StatelessWidget {
  const FeatureButtons({super.key});



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
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/calendar.svg', width: 20,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
                ),
              ),
              Text('Đặt lịch', style: TextStyle(fontSize: 13),)
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/clock.svg', color: Colors.blue,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
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
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/shield.svg'),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
                ),
              ),
              Text('Quá trình\nđiều trị',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/picture.svg', width: 20,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
                ),
              ),
              Text('Ảnh điều trị', style: TextStyle(fontSize: 13),)
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/toothbrush.svg', width: 22,),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
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
                onPressed: (){},
                icon: SvgPicture.asset('assets/icons/catalog.svg', width: 24),
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blueGrey[50]
                ),
              ),
              Text('Danh mục\ndịch vụ',
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
