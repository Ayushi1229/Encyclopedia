import 'package:encyclopedia/splash/splash_screen.dart';
import 'package:encyclopedia/utils/import_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'responsive_design/responsive_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Make status bar transparent so it merges with AppBar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // White icons
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Animal Encyclopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9CCC65)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9CCC65), // ✅ Light Green 400
          foregroundColor: Colors.white,       // ✅ AppBar text/icons white
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            // statusBarColor: Color(0xFF9CCC65), // ✅ Status bar same as AppBar
            statusBarIconBrightness: Brightness.light, // White icons
          ),
        ),
      ),
      home: const SplashScreen(
        appLogo: 'APP_LOGO',
        appName: 'APP_NAME',
        appVersion: '1.0.0',
        duLogo: 'DU_LOGO',
        aswdcLogo: 'ASWDC_LOGO',
      ),
    );
  }
}
