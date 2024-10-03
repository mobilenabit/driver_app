import "package:flutter/material.dart";

import "../core/api_client.dart";

class MapDestinationModel with ChangeNotifier {
  Map<String, dynamic>? value;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadMapDestinations() async {
    _isLoading = true;
    notifyListeners();

    return apiClient.getMapDestinations().then((res) {
      value = res;
      print(value);
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
    });
  }
}
