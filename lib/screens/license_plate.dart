import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/core/secure_store.dart';
import 'package:driver_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LicensePlateScreen extends StatefulWidget {
  const LicensePlateScreen({super.key});

  @override
  State<LicensePlateScreen> createState() => _LicensePlateScreenState();
}

class _LicensePlateScreenState extends State<LicensePlateScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredLicensePlates = [];
  List<Map<String, String>> _licensePlateData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLicensePlates();
    _searchController.addListener(_filterLicensePlates);
  }

  Future<void> _fetchLicensePlates() async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    final api = ApiClient();
    final userData = await api.getUserData();
    final userId = userData["data"]["userId"].toString();

    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy dữ liệu biển số xe'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String url =
        'http://pumplogapi.petronet.vn/MD/Driver2Vehicle/GetByDriverId/$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final data = responseData['data'] as List;
          setState(() {
            _licensePlateData = data
                .map(
                  (item) => {
                    'plateNumber': item['vehicle']['numberPlate'].toString(),
                  },
                )
                .toList();
            _filteredLicensePlates = _licensePlateData;
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load license plates');
        }
      }
    } catch (e) {
      print(e);
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  // search
  void _filterLicensePlates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLicensePlates = _licensePlateData.where((plate) {
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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể quay lại trang trước'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // Remove the back button
          title: const Text(
            'Chọn biển số xe',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 243, 247, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm",
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w400),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredLicensePlates.length,
                        itemBuilder: (context, index) {
                          final licensePlate =
                              _filteredLicensePlates[index]['plateNumber'];
                          return ListTile(
                            shape: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              licensePlate!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    selectedLicensePlate: licensePlate,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
