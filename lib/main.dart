import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/screens/flutterMap.dart';
import 'package:driver_app/screens/home.dart';

import 'package:driver_app/screens/login.dart';
import 'package:driver_app/screens/map.dart';


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:const [
        Locale('vi', ''), // Vietnamese
        Locale('en', ''), // English
      ],
      locale: const Locale('vi', ''),
      home: HomeScreen(),
    );
  }
}
