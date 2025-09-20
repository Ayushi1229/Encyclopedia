import '../responsive_pages/mobile_view.dart';
import '../responsive_pages/tablet_view.dart';
import '../responsive_pages/web_view.dart';
import '../utils/import_export.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        if (width <= 550) {
          return SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: MobileView(),
          );
        } else if (width <= 1280) {
          return SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: TabView(),
          );
        } else if (width <= 1920) {
          return SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: WebView(),
          );
        } else {
          return SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: LargeView(),
          );
        }
      },
    );
  }
}
