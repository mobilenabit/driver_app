import 'package:driver_app/screens/qr_result.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class ScanQrScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const ScanQrScreen({super.key, required this.userData});

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

  // Validate the scanned QR code
  bool isValidQrCode(String code) {
    return code.startsWith('000201') &&
        code.contains('A000000727') &&
        code.contains('QRIBFTTA') &&
        code.contains('5802VN') &&
        code.contains('5303704') &&
        code.contains('0208QRIBFTTA');
  }

  // Show alert if QR code is not valid
  void showInvalidQrAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog();
      },
    );

    // Automatically dismiss the alert after 1 seconds
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
        setState(() {
          isScanCompleted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Quét mã QR',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
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
                        // Validate the QR code
                        if (isValidQrCode(code)) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return QrResultScreen(
                                  code: code,
                                  userData: widget.userData ??
                                      {
                                        'data': {
                                          'avatar':
                                              'https://example.com/avatar.jpg'
                                        }
                                      },
                                );
                              },
                            ),
                          );

                          // Reset scan state based on the result
                          if (result == true) {
                            setState(() {
                              isScanCompleted = false;
                            });
                          }
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

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.14,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ảnh QR code không đúng định dạng nhà cung cấp, vui lòng chọn ảnh khác',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
