import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";


class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavigationPageState();
  }
}

class _NavigationPageState extends State<HomePage>{
  int _index = 0;
  final pages = [
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages,),
      bottomNavigationBar: NavigationBar(
          height: 100,
          selectedIndex: _index,
          onDestinationSelected: (i){
            setState(() {
              _index = i;
            });
          },
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states){
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
                color: selected ? Colors.blue : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold
            );
          }),
          // indicatorColor: Colors.cyan,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                "assets/icons/home_outline_minus.svg", color: Colors.grey,
                height: 20,
              ),
              selectedIcon: SvgPicture.asset(
                "assets/icons/home_outline_minus.svg", color: Colors.blue,
                height: 20
              ),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                "assets/icons/tooth-svgrepo-com.svg", color: Colors.grey,
                height: 20,
              ),
              selectedIcon: SvgPicture.asset(
                  "assets/icons/tooth-svgrepo-com.svg", color: Colors.blue,
                height: 20
              ),
              label: 'Dịch vụ',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/calendar-svgrepo-com-3.svg",
                  height: 45,
                ),
                label: 'Đặt lịch',
              ),
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                "assets/icons/basket_minus.svg", color: Colors.grey,
                height: 20,
              ),
              selectedIcon: SvgPicture.asset(
                  "assets/icons/basket_minus.svg", color: Colors.blue,
                height: 20
              ),
              label: 'Sản phẩm',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                "assets/icons/user_outline.svg", color: Colors.grey,
                height: 20,
              ),
              selectedIcon: SvgPicture.asset(
                  "assets/icons/user_outline.svg", color: Colors.blue,
                height: 20
              ),
              label: 'Cá nhân',
            )
          ]
      ),
    );
  }
}