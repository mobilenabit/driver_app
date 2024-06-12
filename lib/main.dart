import 'package:driver_app/screens/gas_station.dart';
import 'package:driver_app/screens/history.dart';
import 'package:driver_app/screens/home.dart';
import 'package:driver_app/screens/info.dart';
import 'package:driver_app/screens/license_plate.dart';
import 'package:flutter/material.dart';
import "screens/login.dart";
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HistoryScreen(),
    );
  }
}
