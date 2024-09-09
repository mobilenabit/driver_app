import 'package:flutter/material.dart';



class LicensePlateModel extends ChangeNotifier {
  String _licensePlate = "30A-123.45";

  String get licensePlate => _licensePlate;

  void setLicensePlate(String newLicensePlate) {
    _licensePlate = newLicensePlate;
    notifyListeners();
  }
}
