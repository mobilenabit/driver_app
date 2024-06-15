import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver_app/screens/gas_station.dart';
import 'package:driver_app/screens/promotion.dart';
import 'package:driver_app/screens/qr_code.dart';
import 'package:driver_app/screens/statistics.dart';

class InfoScreen extends StatefulWidget {
  final String selectedLicensePlate;
  const InfoScreen({super.key, required this.selectedLicensePlate});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

List<Mainproperty> _item = [
  Mainproperty(
      text: 'Quét Qr',
      svgAsset: 'assets/icons/qr_code.svg',
      screen: const ScanQrScreen()),
  Mainproperty(
      text: 'CHXD',
      svgAsset: 'assets/icons/map.svg',
      screen: const GasStationScreen()),
  Mainproperty(
      text: 'Thông báo',
      svgAsset: 'assets/icons/notifications.svg',
      screen: const PromotionScreen()),
  Mainproperty(
      text: 'Thống kê',
      svgAsset: 'assets/icons/thống_kê.svg',
      screen: const StatisticsScreen(selectedLicensePlate: '',)),
];

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC923),
              Color(0xFFF2CC),
              Color(0xFFFFFF),
              Color(0xFFFFFF)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: Container(
                      height: size.height * 0.085,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phạm Thu Giang',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.selectedLicensePlate,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    'Tính năng chính:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.5,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _item.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: size.width * 0.005,
                        crossAxisSpacing: size.height * 0.005,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => _item[index].screen,
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
                                color: const Color.fromARGB(255, 236, 213, 213),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(_item[index].svgAsset),
                                  Text(_item[index].text),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mainproperty {
  final String text;
  final String svgAsset;
  final Widget screen;

  Mainproperty(
      {required this.text, required this.svgAsset, required this.screen});
}
