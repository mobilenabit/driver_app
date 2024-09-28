import 'package:driver_app/core/localizations.dart';
import 'package:driver_app/core/secure_store.dart';
import 'package:driver_app/screens/home.dart';
import 'package:driver_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:relative_time/relative_time.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: FToastBuilder(),
        title: "Driver App",
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "SF Pro",
        ),
        localizationsDelegates: const [
          CustomLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          RelativeTimeLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale("vi", ""),
        ],
        home: FutureBuilder(
          future: secureStorage.readSecureData("logged_in"),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ));
  }
}
