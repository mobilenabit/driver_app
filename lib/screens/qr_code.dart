import 'package:driver_app/screens/qr_result.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Quét Qr',
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
              color: isFlashOn ? Colors.white : Colors.black,
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
              color: isFrontCamera ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Scan Qr here')],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (barcode) {
                      if (!isScanCompleted) {
                        isScanCompleted = true;
                        String code = barcode.barcodes.first.rawValue ?? "---";
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
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.black26,
                    borderColor: Colors.amber.shade900,
                    borderRadius: 12,
                    borderStrokeWidth: 10,
                    scanAreaHeight: 250,
                    scanAreaWidth: 250,
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Result'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
