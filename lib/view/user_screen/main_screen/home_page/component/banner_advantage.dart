import 'dart:async';

import 'package:flutter/material.dart';

class BannerAdvantage extends StatefulWidget {
  const BannerAdvantage({super.key});

  @override
  State<BannerAdvantage> createState() => _BannerAdvantageState();
}

class _BannerAdvantageState extends State<BannerAdvantage> {

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.png'
  ];
  final _pageContrl = PageController();
  int currentPage = 0;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageContrl.hasClients) { 
        if (currentPage < banners.length - 1) {
          currentPage++;
        } else {
          currentPage = 0;
        }
        _pageContrl.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageContrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageContrl,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(banners[index], fit: BoxFit.cover,),
            );
          },
          itemCount: banners.length,
          onPageChanged: (index){
          },
        ),
      ),
    );
  }
}
