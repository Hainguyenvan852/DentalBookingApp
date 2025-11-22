import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:dental_booking_app/view/user_screen/main_screen/personal_page/personal_screen.dart";
import "package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/product_catalog_screen.dart";

import "package:dental_booking_app/view/user_screen/main_screen/service_page/service_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "main_screen/home_page/home_page_screen.dart";


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
    ProductCatalogPage(),
    PersonalPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages,),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          SvgPicture.asset("assets/icons/home_outline_minus.svg", color: Colors.white, height: 20,),
          SvgPicture.asset("assets/icons/tooth.svg", color: Colors.white, height: 20),
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
    );
  }
}