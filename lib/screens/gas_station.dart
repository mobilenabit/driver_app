import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GasStationScreen extends StatefulWidget {
  const GasStationScreen({super.key});

  @override
  State<GasStationScreen> createState() => _GasStationScreenState();
}

List<GasMap> _item = [
  GasMap(
      name: 'Trạm Xăng Dầu Petrolomex Xa La',
      address: 'Đ. Cầu Bươu',
      station: 'Trạm xăng',
      distance: '550m',
      iconAsset: 'assets/icons/road.svg',
      status: 'Đang mở cửa'),
  GasMap(
      name: 'Trạm Xăng-HV Quân Y',
      address: '143 Đường Trần Phú',
      station: 'Trạm xăng',
      distance: '1.5km',
      iconAsset: 'assets/icons/road.svg',
      status: 'Đóng cửa')
];

class _GasStationScreenState extends State<GasStationScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 243, 247, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'CHXD gần đây',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _item.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _item[index].name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 2, // Limit the text to 2 lines
                        overflow: TextOverflow
                            .ellipsis, // Add ellipsis if text exceeds 2 lines
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 0.75, color: Colors.grey),
                      ),
                      child: Center(
                        child: SvgPicture.asset(_item[index].iconAsset),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _item[index].station,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(167, 171, 195, 1),
                      ),
                    ),
                    const Text(
                      ' - ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(167, 171, 195, 1),
                      ),
                    ),
                    Text(
                      _item[index].distance,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(167, 171, 195, 1),
                      ),
                    ),
                  ],
                ),
                Text(
                  _item[index].address,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(167, 171, 195, 1),
                  ),
                ),
                Text(
                  _item[index].status,
                  style: TextStyle(
                    fontSize: 13,
                    color: _item[index].status == 'Đang mở cửa'
                        ? const Color.fromRGBO(22, 197, 29, 0.53)
                        : const Color.fromRGBO(197, 22, 22, 0.53),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GasMap {
  final String name;
  final String address;
  final String distance;
  final String iconAsset;
  final String status;
  final String station;

  GasMap({
    required this.name,
    required this.address,
    required this.distance,
    required this.iconAsset,
    required this.status,
    required this.station,
  });
}
