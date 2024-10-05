import "package:flutter/material.dart";

import "../core/api_client.dart";

class ProductNamesModel with ChangeNotifier {
  Map<String, dynamic>? value;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadProductNames() async {
    _isLoading = true;
    notifyListeners();

    return apiClient.getProductNames().then((res) {
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
