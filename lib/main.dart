import 'package:driver_app/app.dart';
import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/models/licensePlate.dart';
import 'package:driver_app/screens/account.dart';

import 'package:driver_app/screens/home.dart';
import 'package:driver_app/screens/info_test.dart';
import 'package:driver_app/screens/login.dart';
import 'package:driver_app/screens/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LicensePlateModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserDataModel()..loadUserData(),
        ),
      ],
      child: const App(),
    ),
  );
}
