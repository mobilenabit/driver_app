import 'package:driver_app/core/api_client.dart';
import 'package:flutter/material.dart';

class DriverModel with ChangeNotifier {
  Map<String, dynamic>? value;
  Map<String, dynamic>? userData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadDriver() async {
    _isLoading = true;
    notifyListeners();

    await apiClient.getUserData().then((res) {
      userData = res["data"];
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });

    return apiClient.getDriver(userData?["userId"]).then((res) {
      print(res["data"]);
      value = res["data"][0];
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });
  }
}
