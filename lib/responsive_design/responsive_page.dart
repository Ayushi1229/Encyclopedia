import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../responsive_pages/large_view.dart';
import '../responsive_pages/mobile_view.dart';
import '../responsive_pages/tablet_view.dart';
import '../responsive_pages/web_view.dart';

//
// void main() {
//   runApp(const ResponsivePage());
// }

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          if (width <= 550) {
            return SafeArea(child: MobileView());
          } else if (width > 550 && width <= 1280) {
            return SafeArea(child: TabView());
          } else if (width > 1280 && width <= 1920) {
            return SafeArea(child: WebView());
          } else {
            return SafeArea(child: LargeView());
          }
        },
      ),
    );
  }
}
