import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/licensePlate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

class LicensePlateScreen extends StatefulWidget {
  const LicensePlateScreen({super.key});

  @override
  State<LicensePlateScreen> createState() => _LicensePlateScreenState();
}

List<GasMap> _item = [
  GasMap(
    name: '30A-123.45',
  ),
  GasMap(
    name: '30A-123.56',
  ),
  GasMap(
    name: '30A-132.45',
  ),
  GasMap(
    name: '30A-223.45',
  ),
  GasMap(
    name: '30A-223.89',
  ),
  GasMap(
    name: '30A-143.25',
  ),
  GasMap(
    name: '30A-143.45',
  ),
  GasMap(
    name: '30A-893.45',
  ),
  GasMap(
    name: '30A-243.60',
  ),
];

class _LicensePlateScreenState extends State<LicensePlateScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GasMap> _filteredgasStation = [];
  final List<GasMap> _gasStation = _item;
  LicensePlateModel? licensePlateModel;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _filteredgasStation = _gasStation;
    _searchController.addListener(_filtergasStation);
  }

  Future<void> getUserData() async {
    try {
      final response = await apiClient.getUserData();
      if (response["success"]) {
        setState(() {
          userData = response["data"];
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<void> getLicensePlate() async {
  //   try {
  //     final response = await apiClient.getVehicles(userData!["id"]);

  //   }
  // }

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    licensePlateModel = context.read<LicensePlateModel>();

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
          'Đổi xe',
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
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        licensePlateModel?.setLicensePlate(gas.name);
                        Navigator.pop(context, gas.name);
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              gas.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            LucideIcons.chevron_right,
                            color: Color.fromRGBO(145, 145, 159, 1),
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

  GasMap({
    required this.name,
  });
}
