import 'dart:convert';

import 'package:driver_app/screens/qr_result.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isScanCompleted = false;
  MobileScannerController cameraController = MobileScannerController();

  void closeScreen() {
    isScanCompleted = false;
  }

  // Add API QR of VietQR
  // Future<bool> validVietQr(String code) async {
  //   final response = await http.post(
  //       Uri.parse(
  //           'https://img.vietqr.io/image/<BANK_ID>-<ACCOUNT_NO>-<TEMPLATE>.png?amount=<AMOUNT>&addInfo=<DESCRIPTION>&accountName=<ACCOUNT_NAME>'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'qr_code': code,
  //       }));

  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     return responseData['isValid'];
  //   } else {
  //     throw Exception('Failed to validate QR code');
  //   }
  // }

  // show alert if qr not valid
  void showInvalidQrAlert() {
    showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return AlertDialog(
            title: Icon(Icons.error),
            content: const Text(
              'Ảnh QR code không đúng định dạng nhà cung cấp, vui lòng chọn ảnh khác',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isScanCompleted = false;
                    });
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF0),
        automaticallyImplyLeading: false,
        title: const Text(
          'Quét mã QR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        
                  
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch();
            },
            icon: Icon(
              Icons.flashlight_on_outlined,
              color: isFlashOn ? Colors.amber : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              cameraController.switchCamera();
            },
            icon: Icon(
              Icons.flip_camera_android,
              color: isFrontCamera ? Colors.amber : Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFF7DD),
              Color(0xFFFFFBF0),
            ])),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (barcode) async {
                      if (!isScanCompleted) {
                        isScanCompleted = true;
                        String code = barcode.barcodes.first.rawValue ?? "---";
                        // TODO: add validation type of QR
                        //bool isValid = await validVietQr(code);
                        bool isValid = code != "---";
                        if (isValid) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return QrResultScreen(
                                  code: code,
                                  closeScreen: closeScreen,
                                );
                              },
                            ),
                          );
                        } else {
                          showInvalidQrAlert();
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.black26,
                    borderColor: Colors.amber.shade900,
                    borderRadius: 10,
                    borderStrokeWidth: 3,
                    scanAreaHeight: 250,
                    scanAreaWidth: 250,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.08, bottom: size.height * 0.02),
                    child: const Text(
                      'Chấp nhận mã QR:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/vietqr.svg'),
                      SvgPicture.asset('assets/icons/vnpay.svg'),
                      SvgPicture.asset('assets/icons/napas.svg'),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/cancel.svg',
                width: 75,
                height: 75,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.03),
              child: const Text(
                'Hủy quét mã',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
