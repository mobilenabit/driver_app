import 'package:driver_app/screens/gas_station.dart';
import 'package:driver_app/screens/promotion.dart';
import 'package:driver_app/screens/qr_code.dart';
import 'package:driver_app/screens/statistics.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../components/user_info_card.dart';
import '../core/api_client.dart';

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
  Future<Map<String, dynamic>>? _pumpData;

  @override
  void initState() {
    super.initState();
    _pumpData = ApiClient().getPumps();
  }

  List<Mainproperty> _item(BuildContext context) {
    return [
      Mainproperty(
        text: 'Quét Qr',
        svgAsset: 'assets/icons/qr_code.svg',
        screenBuilder: (context) => const ScanQrScreen(),
      ),
      Mainproperty(
        text: 'CHXD',
        svgAsset: 'assets/icons/map.svg',
        screenBuilder: (context) => const GasStationScreen(),
      ),
      Mainproperty(
        text: 'Thông báo',
        svgAsset: 'assets/icons/notifications.svg',
        screenBuilder: (context) => const PromotionScreen(),
      ),
      Mainproperty(
        text: 'Thống kê',
        svgAsset: 'assets/icons/thống_kê.svg',
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
              Color(0xFFFFC923),
              Color(0xFFFFF2CC),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ],
            stops: [0.01 / 100, 72.27 / 100, 100.79 / 100, 100.79 / 100],
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
                        'Tính năng chính:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap:
                        true, // This is needed to avoid layout issues with GridView inside SingleChildScrollView
                    itemCount: _item(context).length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: size.width * 0.001,
                      crossAxisSpacing: size.height * 0.001,
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
                                SvgPicture.asset(item.svgAsset),
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
