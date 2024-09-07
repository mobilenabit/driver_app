import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GasStationScreen extends StatefulWidget {
  final List<GasMap> gasStations;

  const GasStationScreen({
    super.key,
    required this.gasStations,
  });

  @override
  State<GasStationScreen> createState() => _GasStationScreenState();
}

class _GasStationScreenState extends State<GasStationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GasMap> _filteredGasStation = [];
  late List<GasMap> _gasStation;

  @override
  void initState() {
    super.initState();
    _gasStation = widget.gasStations;
    _filteredGasStation = _gasStation;
    _searchController.addListener(_filterGasStation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGasStation() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGasStation = _gasStation.where((station) {
        final stationName = station.name.toLowerCase();
        return stationName.contains(query);
      }).toList();
    });
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
                itemCount: _filteredGasStation.length,
                itemBuilder: (context, index) {
                  final gas = _filteredGasStation[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, gas);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
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
                                gas.distance > 1000
                                    ? '${(gas.distance / 1000).toStringAsFixed(1)} km'
                                    : '${gas.distance.toStringAsFixed(1)} m',
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
  final double distance;

  GasMap({
    required this.name,
    required this.address,
    required this.distance,
  });
}
