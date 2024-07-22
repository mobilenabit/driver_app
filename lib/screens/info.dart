import 'package:driver_app/screens/gas_station.dart';
import 'package:driver_app/screens/promotion.dart';
import 'package:driver_app/screens/scan_qr.dart';
import 'package:driver_app/screens/statistics.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../components/user_info_card.dart';

class InfoScreen extends StatefulWidget {
  final String selectedLicensePlate;
  final Map<String, dynamic>? userData;

  const InfoScreen(
      {super.key, required this.userData, required this.selectedLicensePlate});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class Mainproperty {
  final String text;
  final String svgAsset;
  final Widget Function(BuildContext context) screenBuilder;

  Mainproperty({
    required this.text,
    required this.svgAsset,
    required this.screenBuilder,
  });
}

class _InfoScreenState extends State<InfoScreen> {
  //Future<Map<String, dynamic>>? _pumpData;

  @override
  void initState() {
    super.initState();
    //  _pumpData = ApiClient().getPumps();
  }

  List<Mainproperty> _item(BuildContext context) {
    return [
      Mainproperty(
        text: 'Quét Qr',
        svgAsset: 'assets/icons/qrCode.png',
        screenBuilder: (context) => ScanQrScreen(
          userData: widget.userData,
        ),
      ),
      Mainproperty(
        text: 'CHXD',
        svgAsset: 'assets/icons/maps.png',
        screenBuilder: (context) => const GasStationScreen(),
      ),
      Mainproperty(
        text: 'Thông báo',
        svgAsset: 'assets/icons/notifications.png',
        screenBuilder: (context) => const PromotionScreen(),
      ),
      Mainproperty(
        text: 'Thống kê',
        svgAsset: 'assets/icons/line_chart.png',
        screenBuilder: (context) => StatisticsScreen(
          selectedLicensePlate: widget.selectedLicensePlate,
          userData: widget.userData,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4e86af),
              Color(0xFFbcd1e1),
              Colors.white,
              Colors.white,
            ],
            stops: [
              0.01 / 100,
              72.27 / 100,
              100.79 / 100,
              100.79 / 100,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.only(
                      top: 10,
                      start: 16,
                      end: 16,
                    ),
                    child: UserInfoCard(
                      userName: widget.userData?["data"]["displayName"] ?? "",
                      selectedLicensePlate: widget.selectedLicensePlate,
                      //userId: widget.userData?["data"]["id"],
                      avatar: widget.userData?["data"]["avatar"] ?? "",
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05, top: size.height * 0.05),
                      child: const Text(
                        'Tính năng chính',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap:
                        true, // This is needed to avoid layout issues with GridView inside SingleChildScrollView
                    itemCount: _item(context).length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemBuilder: (context, index) {
                      final item = _item(context)[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item.screenBuilder(context),
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  item.svgAsset,
                                ),
                                Text(item.text),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
