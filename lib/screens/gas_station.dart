import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
    distance: '550m',
  ),
  GasMap(
    name: 'Trạm Xăng-HV Quân Y',
    address: '143 Đường Trần Phú',
    distance: '1.5km',
  ),
];

class _GasStationScreenState extends State<GasStationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GasMap> _filteredgasStation = [];
  final List<GasMap> _gasStation = _item;

  // Search
  void _filtergasStation() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredgasStation = _gasStation.where((station) {
        final stationName = station.name.toLowerCase();
        return stationName.contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredgasStation = _gasStation;
    _searchController.addListener(_filtergasStation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Cửa hàng xăng dầu',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Search
            Container(
              margin: const EdgeInsets.only(
                top: 25,
                left: 25,
                right: 25,
                bottom: 25,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(226, 226, 226, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(145, 145, 159, 1),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // List gas station
            Expanded(
              child: ListView.builder(
                itemCount: _filteredgasStation.length,
                itemBuilder: (context, index) {
                  final gas = _filteredgasStation[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 15.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/gas.svg',
                            width: 14,
                            height: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gas.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                gas.address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(145, 145, 159, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              gas.distance,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Icon(
                              LucideIcons.arrow_right,
                              color: Color.fromRGBO(189, 189, 189, 1),
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GasMap {
  final String name;
  final String address;
  final String distance;

  GasMap({
    required this.name,
    required this.address,
    required this.distance,
  });
}
