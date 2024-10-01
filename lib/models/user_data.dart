import "package:flutter/material.dart";

import "../core/api_client.dart";

class UserDataModel with ChangeNotifier {
  Map<String, dynamic>? value;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadUserData() async {
    _isLoading = true;
    notifyListeners();

    return apiClient.getUserData().then((res) {
      value = res["data"];
      print(value);
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });
  }
}
