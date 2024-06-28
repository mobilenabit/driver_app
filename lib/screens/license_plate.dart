import 'package:driver_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LicensePlateScreen extends StatefulWidget {
  LicensePlateScreen({super.key});

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
    String userId = "30071";
    String token =
        'eyJhbGciOiJSUzI1NiIsImtpZCI6IjlEMEM3RUI5RTNDMkNCMEFENDY5NEEyREY3MjJDNkE3IiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE3MTk1NjcxOTUsImV4cCI6MTcyODIwNzE5NSwiaXNzIjoiaHR0cDovL3B1bXBsb2dhcGkucGV0cm9uZXQudm4vY29yZSIsImNsaWVudF9pZCI6Im5hYml0LWNsaWVudCIsInN1YiI6IjMwMDcwIiwiYXV0aF90aW1lIjoxNzE5NTY3MTk1LCJpZHAiOiJsb2NhbCIsInVzZXJpZCI6IjMwMDcwIiwidXNlcm5hbWUiOiJBTkhUTiIsImRpc3BsYXluYW1lIjoiVOG6oSBOZ-G7jWMgQW5oIiwiZW1haWwiOiJlbWFpbEBuYWJpdC5jb20udm4iLCJwaG9uZW51bWJlciI6IiIsImlzc3VwZXJ1c2VyIjoiIiwiYnJhbmNoSWQiOiIxMTEiLCJzdGFydFBhZ2VJZCI6IiIsInR5cGVJZCI6IjEiLCJqdGkiOiI4REZGMURFQUYyMjQ1MTI3NkFGRTgwODY2MEQ4QTJFNCIsImlhdCI6MTcxOTU2NzE5NSwic2NvcGUiOlsiZW1haWwiLCJvcGVuaWQiLCJwcm9maWxlIl0sImFtciI6WyJwYXNzd29yZCJdfQ.4tLL97o9TlkhF__TIK3fT0q4Nf8WkS_BKjLRpKYMHWouS0txyECig0HVYJs91CfgWU2F2WzIrd7nFOLoVEtjFii15Gz1gPjqdzEwF9Zbb0nHyQAO6-KSqzFVbzBBTVsPCVqBKeAhUa8djq05ulpQhKHADvrmT8Ud7YqkGJ3QZAsgyq8hhxJclqe7nxVx_BgQH8CiGCso0EiqZ7tRPgCNbCcu4oSQXM6iL2E1eSqiCz8A9-6gt5fZG_pfurxtweKRiRNb_qCObngh5yZtssSsP8wvoS8ffpNsM2Y13hvXemdDs1qTf5Y4RZilwOrPE8sOL-JLDvnQPriGAk6uaLKFig';
    String url =
        'http://pumplogapi.petronet.vn/MD/Driver2Vehicle/GetByDriverId/$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final data = responseData['data'] as List;
          setState(() {
            _licensePlateData = data
                .map((item) =>
                    {'plateNumber': item['vehicle']['numberPlate'].toString()})
                .toList();
            _filteredLicensePlates = _licensePlateData;
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load license plates');
        }
      } else {
        throw Exception('Failed to load license plates');
      }
    } catch (e) {
      print(e);
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
          automaticallyImplyLeading: false, // Remove the back button
          title: const Text(
            'Chọn biển số xe',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                          vertical: 15,
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
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          title: Text(licensePlate!),
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
    );
  }
}
