import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:dental_booking_app/view/main_ui/booking_page/booking_page.dart";
import "package:dental_booking_app/view/main_ui/product_catalog_page/product_catalog_page.dart";
import "package:dental_booking_app/view/main_ui/profile_page/profile_page.dart";
import "package:dental_booking_app/view/main_ui/service_page/service_page.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "home_page/home_page.dart";


class NavigationPage extends StatefulWidget{

  const NavigationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavigationPageState();
  }
}

class _NavigationPageState extends State<NavigationPage>{
  int _index = 0;
  final pages = [
    HomePage(),
    ServicePage(),
    // BookingPage(initService: null,),
    ProductCatalogPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages,),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          SvgPicture.asset("assets/icons/home_outline_minus.svg", color: Colors.white, height: 20,),
          SvgPicture.asset("assets/icons/tooth.svg", color: Colors.white, height: 20),
          // SvgPicture.asset("assets/icons/calendar-circle.svg", height: 48, color: Colors.white),
          SvgPicture.asset("assets/icons/basket_minus.svg", color: Colors.white, height: 20),
          SvgPicture.asset("assets/icons/user_outline.svg", color: Colors.white, height: 20),
        ],
        index: _index,
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        color: Colors.lightBlue.shade200,
        height: 65,
        onTap: (i){
          setState(() {
            _index = i;
          });
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Transform.translate(
      //   offset: Offset(0, 20),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       SizedBox(
      //         height: 48, width: 48,
      //         child: FloatingActionButton(
      //           onPressed: () {
      //             Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(initService: null,)));
      //           },
      //           child: SvgPicture.asset("assets/icons/calendar-circle.svg", height: 56),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       const Text('Đặt lịch', style: TextStyle(
      //           color: Colors.blue,
      //           fontSize: 12,
      //           fontWeight: FontWeight.bold
      //       ),),
      //     ],
      //   ),
      // ),
    );
  }
}

// NavigationBar(
// height: 95,
// selectedIndex: _index,
// onDestinationSelected: (i){
// setState(() {
// _index = i;
// });
// },
// labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states){
// final selected = states.contains(WidgetState.selected);
// return TextStyle(
// color: selected ? Colors.blue : Colors.grey,
// fontSize: 12,
// fontWeight: FontWeight.bold
// );
// }),
// destinations: [
// Padding(
// padding: const EdgeInsets.only(bottom: 20),
// child: NavigationDestination(
// icon: SvgPicture.asset(
// "assets/icons/home_outline_minus.svg", color: Colors.grey,
// height: 20,
// ),
// selectedIcon: SvgPicture.asset(
// "assets/icons/home_outline_minus.svg", color: Colors.blue,
// height: 20
// ),
// label: 'Trang chủ',
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(bottom: 20),
// child: NavigationDestination(
// icon: SvgPicture.asset(
// "assets/icons/tooth.svg", color: Colors.grey,
// height: 20,
// ),
// selectedIcon: SvgPicture.asset(
// "assets/icons/tooth.svg", color: Colors.blue,
// height: 20
// ),
// label: 'Dịch vụ',
// ),
// ),
// SizedBox(
// width: 40,
// height: 30,
// ),
// Padding(
// padding: const EdgeInsets.only(bottom: 20),
// child: NavigationDestination(
// icon: SvgPicture.asset(
// "assets/icons/basket_minus.svg", color: Colors.grey,
// height: 20,
// ),
// selectedIcon: SvgPicture.asset(
// "assets/icons/basket_minus.svg", color: Colors.blue,
// height: 20
// ),
// label: 'Sản phẩm',
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(bottom: 20),
// child: NavigationDestination(
// icon: SvgPicture.asset(
// "assets/icons/user_outline.svg", color: Colors.grey,
// height: 20,
// ),
// selectedIcon: SvgPicture.asset(
// "assets/icons/user_outline.svg", color: Colors.blue,
// height: 20
// ),
// label: 'Cá nhân',
// ),
// )
// ]
// ),