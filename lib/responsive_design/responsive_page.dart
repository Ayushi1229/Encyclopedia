import 'package:flutter/material.dart';
import '../responsive_pages/large_view.dart';
import '../responsive_pages/mobile_view.dart';
import '../responsive_pages/tablet_view.dart';
import '../responsive_pages/web_view.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        if (width <= 550) {
          return  SafeArea(child: MobileView());
        } else if (width <= 1280) {
          return  SafeArea(child: TabView());
        } else if (width <= 1920) {
          return  SafeArea(child: WebView());
        } else {
          return  SafeArea(child: LargeView());
        }
      },
    );
  }
}
