import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

List<Mainproperty> _item = [
  Mainproperty(text: 'Quét Qr', svgAsset: 'assets/icons/qr_code.svg'),
  Mainproperty(text: 'CHXD', svgAsset: 'assets/icons/map.svg'),
  Mainproperty(text: 'Thông báo', svgAsset: 'assets/icons/notifications.svg'),
  Mainproperty(text: 'Thống kê', svgAsset: 'assets/icons/thống_kê.svg'),
];

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
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
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  'Tính năng chính',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.5,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: size.width * 0.005,
                      crossAxisSpacing: size.height * 0.005,
                    ),
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 236, 213, 213),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Mainproperty {
  final String text;
  final String svgAsset;

  Mainproperty({required this.text, required this.svgAsset});
}
