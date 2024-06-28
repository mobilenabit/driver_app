
import 'package:driver_app/screens/history.dart';
import 'package:driver_app/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ], supportedLocales: [
      Locale('vi', ''), // Vietnamese
      Locale('en', ''), // English
    ], locale: Locale('vi', ''), home: LoginScreen());
  }
}
