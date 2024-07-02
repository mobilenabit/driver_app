import "dart:convert";

import "package:driver_app/core/api_client.dart";
import "package:driver_app/core/secure_store.dart";
import 'package:http/http.dart' as http;
import "package:driver_app/screens/chart/bar_graph.dart";
import "package:flutter/material.dart";

import "package:intl/intl.dart";

class StatisticsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String selectedLicensePlate;
  StatisticsScreen(
      {super.key, required this.selectedLicensePlate, required this.userData});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

const List<double> gasolineTotal = [
  3000,
  1000,
  510,
];

enum ChoiceMonth {
  all,
  month1,
  month2,
  month3,
}

// auto subtract days to get month
extension ChoiceMonthExtension on ChoiceMonth {
  String get label {
    switch (this) {
      case ChoiceMonth.all:
        return "Tất cả";
      case ChoiceMonth.month1:
        return "Tháng ${DateFormat('MM').format(DateTime.now().subtract(const Duration(days: 30)))}";
      case ChoiceMonth.month2:
        return "Tháng ${DateFormat('MM').format(DateTime.now().subtract(const Duration(days: 60)))}";
      case ChoiceMonth.month3:
        return "Tháng ${DateFormat('MM').format(DateTime.now().subtract(const Duration(days: 90)))}";
      default:
        return "";
    }
  }

  String get dateRange {
    switch (this) {
      case ChoiceMonth.all:
        return 'Từ ${DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 30)))} - đến ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';
      case ChoiceMonth.month1:
        return 'Từ ${DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 60)))} - đến ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';
      case ChoiceMonth.month2:
        return 'Từ ${DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 90)))} - đến ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';
      case ChoiceMonth.month3:
        return 'Từ ${DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 120)))} - đến ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';
      default:
        return '';
    }
  }
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int? chosenIndex;
  final TextEditingController _searchController = TextEditingController();
  ChoiceMonth selectedMonth = ChoiceMonth.all;
  List<Map<String, String>> _filteredLicensePlates = [];
  List<Map<String, String>> _licensePlateData = [];
  bool _isLoading = true;

  // set avatar
  Widget _getAvatarWidget() {
    if (widget.userData?['data']['avatar'] != null &&
        widget.userData?['data']['avatar'].isNotEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(widget.userData?['data']['avatar']),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const Icon(Icons.account_circle, size: 40);
    }
  }

  // Get API licensePlates
  Future<void> _fetchLicensePlates() async {
    final api = ApiClient();
    final userData = await api.getUserData();
    final userId = userData['data']['userId'].toString();

    final apiToken = await SecureStorage().readSecureData("access_token");
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
                .map((item) =>
                    {'plateNumber': item['vehicle']['numberPlate'].toString()})
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
  void initState() {
    super.initState();
    _fetchLicensePlates();
    _searchController.addListener(_filterLicensePlates);
  }

  void dispose() {
    _searchController.removeListener(_filterLicensePlates);
    _searchController.dispose();
    super.dispose();
  }

  // show modal bottom
  void _handleLocationChoice() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.6,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Chọn biển số xe",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF3F3F7),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
                      controller: controller,
                      itemCount: _filteredLicensePlates.length,
                      itemBuilder: (BuildContext context, int index) {
                        final plateNumber =
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
                            plateNumber!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              chosenIndex = _licensePlateData.indexWhere(
                                  (element) =>
                                      element['plateNumber'] ==
                                      _filteredLicensePlates[index]
                                          ["plateNumber"]);
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Lịch sử đổ xăng",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.03),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            _getAvatarWidget(),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.userData == null
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        widget.userData?['data']['displayName'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                chosenIndex == null
                                    ? Text(
                                        widget.selectedLicensePlate,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF82869E),
                                        ),
                                      )
                                    : Text(
                                        '${_licensePlateData[chosenIndex!]['plateNumber']}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF82869E),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8FC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            weight: 100,
                            color: Color(0xFF1B1D29),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _handleLocationChoice();
                    },
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Tổng số lít"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "8,286L",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownMenu(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              selectedTrailingIcon:
                                  const Icon(Icons.expand_less),
                              trailingIcon: const Icon(Icons.expand_more),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        Colors.white),
                                surfaceTintColor:
                                    const MaterialStatePropertyAll(
                                        Colors.white),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              initialSelection: ChoiceMonth.all.name,
                              onSelected: (value) {
                                setState(() {
                                  selectedMonth = ChoiceMonth.values.firstWhere(
                                    (element) => element.name == value,
                                  );
                                });
                              },
                              dropdownMenuEntries: ChoiceMonth.values
                                  .map(
                                    (e) => DropdownMenuEntry(
                                        value: e.name, label: e.label),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedMonth.dateRange,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF82869E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        SizedBox(
                            //TODO: This bar graph is NOT dynamic, fix later.
                            height: size.height * 0.4,
                            child:
                                const MyBarGraph(gasolineTotal: gasolineTotal))
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.025,
                              height: size.width * 0.025,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3A9EFC),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "RON 95",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.025,
                              height: size.width * 0.025,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1EBB4D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "E5 RON 92",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.025,
                              height: size.width * 0.025,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE43434),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "DO 0,05S-II",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
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
