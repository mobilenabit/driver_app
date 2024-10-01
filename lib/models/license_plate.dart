import 'package:driver_app/core/api_client.dart';
import 'package:flutter/material.dart';

class LicensePlateModel with ChangeNotifier {
  Map<String, dynamic>? value;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? licensePlate;

  void loadLicensePlate() async {
    _isLoading = true;
    notifyListeners();

    await apiClient.getUserData().then((res) {
      value = res["data"];
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });

    return await apiClient.getActiveVehicle(value?["id"]).then((res) {
      licensePlate = res["data"]["vehicle"]["vehicleCode"];
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void setLicensePlate(Map<String, dynamic> newLicensePlate) async {
    licensePlate = newLicensePlate["vehicle"]["vehicleCode"];

    await apiClient
        .setActiveVehicle(value?["id"], newLicensePlate["vehicleId"])
        .then((res) {})
        .catchError((e) {
      throw Exception("Failed to set active vehicle");
    });

    notifyListeners();
  }
}
