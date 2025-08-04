
import 'package:encyclopedia/firstpage/firstpage_view.dart';
import 'package:encyclopedia/responsive_design/responsive_page.dart';
import 'package:encyclopedia/responsive_pages/mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'view/firstpage_combined.dart';

void main() {
  // databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Encyclopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: ResponsivePage(),
      //     home: HomeScreen(),
    );
  }
}
  
