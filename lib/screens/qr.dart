import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:driver_app/models/product_names.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/screens/qr_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String QrCodeString = "";
  bool _polling = true;
  bool _QrPolling = true;

  @override
  void initState() {
    super.initState();
  }

  Future<String> generateQrCode() async {
    final id = context.read<UserDataModel>().value?["id"];
    try {
      final response = await apiClient.generateQrCode(id);

      if (response["success"]) {
        print(response["data"]);
        return response["data"];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<void> pollQR() async {
    if (_QrPolling) {
      var response = await generateQrCode();

      while (response == null) {
        print(response);
        await Future.delayed(const Duration(seconds: 180));
        response = await generateQrCode();

        if (!_QrPolling) {
          return;
        }
      }

      setState(() {
        _QrPolling = false;
        QrCodeString = response;
      });
    }
  }

  Future<void> pollApi(BuildContext context) async {
    var vehiclePlate = context.read<LicensePlateModel>().licensePlate!;
    if (_polling) {
      final userData = context.read<UserDataModel>().value;
      var response = await apiClient.getConfirmation(userData?["id"]);

      while (response["data"] == null) {
        await Future.delayed(const Duration(seconds: 10));
        response = await apiClient.getConfirmation(userData?["id"]);

        if (!_polling) {
          return;
        }
      }

      setState(() {
        _polling = false;
      });

      if (response["data"] != null && response["data"]["orderId"] != null) {
        pushScreenWithoutNavBar(
            context,
            QrResultScreen(
                orderId: response["data"]["orderId"],
                vehiclePlate: vehiclePlate));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pollQR();
    pollApi(context);
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Consumer3<UserDataModel, ProductNamesModel, LicensePlateModel>(
      builder: (context, userData, productNames, licensePlate, child) =>
          Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: color,
          title: const Text(
            'QR của tôi',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/xangdau-page-title-mb 1.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 350,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    userData.value?["displayName"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: List.generate(
                        150 ~/ 5,
                        (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0
                                ? Colors.transparent
                                : const Color.fromRGBO(179, 179, 179, 1),
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  QrImageView(
                    data: QrCodeString,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     pushScreenWithoutNavBar(
                  //       context,
                  //       const QrResultScreen(),
                  //     );
                  //   },
                  //   child: Text(
                  //     'Debug',
                  //     style: TextStyle(
                  //       fontSize: 15,
                  //       color: color,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
