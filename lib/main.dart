import 'package:flutter/material.dart';
import './pages/home_page.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      // theme: ThemeData(
      //     primarySwatch: Colors.red,
      //     ),
      home: HomePage(),
    );
  }
}
