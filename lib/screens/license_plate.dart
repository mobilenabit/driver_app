import 'package:driver_app/screens/home.dart';
import 'package:flutter/material.dart';

class LicensePlateScreen extends StatefulWidget {
  LicensePlateScreen({super.key});

  @override
  State<LicensePlateScreen> createState() => _LicensePlateScreenState();

  int? chosenIndex;
  int? chosenSegment;
  final licensePlateData = [
    {'plateNumber': '30A-143.45'},
    {'plateNumber': '30A-152.89'},
    {'plateNumber': '30A-325.65'},
    {'plateNumber': '30A-153.75'},
    {'plateNumber': '40A-153.75'},
  ];
}

class _LicensePlateScreenState extends State<LicensePlateScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredLicensePlates = [];

  @override
  void initState() {
    super.initState();
    _filteredLicensePlates = widget.licensePlateData;
    _searchController.addListener(_filterLicensePlates);
  }

  void _filterLicensePlates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLicensePlates = widget.licensePlateData.where((plate) {
        final plateNumber = plate['plateNumber']!.toLowerCase();
        return plateNumber.contains(query);
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text(
          'Chọn biển số xe',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Tìm kiếm",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                fillColor: Color(0xFFF3F3F7),
                border: InputBorder.none,
                filled: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: size.height * 0.025,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLicensePlates.length,
              itemBuilder: (context, index) {
                final licensePlate =
                    _filteredLicensePlates[index]['plateNumber'];
                return ListTile(
                  title: Text(licensePlate!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(selectedLicensePlate: licensePlate),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
