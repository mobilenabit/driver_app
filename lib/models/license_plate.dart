import 'package:driver_app/core/api_client.dart';
import 'package:flutter/material.dart';

class LicensePlateModel with ChangeNotifier {
  Map<String, dynamic>? value;
  Map<String, dynamic>? userData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? licensePlate;

  void loadLicensePlate() async {
    _isLoading = true;
    notifyListeners();

    await apiClient.getUserData().then((res) {
      userData = res["data"];
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });

    return await apiClient.getActiveVehicle(userData?["id"]).then((res) {
      value = res["data"];
      print("Data: ${res["data"]}");
      licensePlate = res["data"]["vehicle"]["vehicleCode"];
      print("License plate: ${res["data"]["vehicle"]["vehicleCode"]}");
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> setLicensePlate(Map<String, dynamic> newLicensePlate) async {
    licensePlate = newLicensePlate["vehicle"]["vehicleCode"];

    var response = await apiClient.setActiveVehicle(
        userData?["id"], newLicensePlate["vehicleId"]);

    print(response);

    if (response["result"]["success"]) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
