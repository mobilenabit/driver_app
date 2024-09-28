import 'package:driver_app/app.dart';
import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/models/licensePlate.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false, 
          create: (_) => LicensePlateModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserDataModel()..loadUserData(),
        ),
        
      ],
      child: const MyApp(),
    ),
  );
}
