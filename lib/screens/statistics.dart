import "package:driver_app/screens/chart/bar_graph.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

class StatisticsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String selectedLicensePlate;
  const StatisticsScreen(
      {super.key, required this.selectedLicensePlate, required this.userData});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

const List<double> gasolineTotal = [
  3000,
  1000,
  510,
];

enum ChoiceLabel {
  all("Tất cả"),
  month1("Tháng 6"),
  month2("Tháng 5"),
  month3("Tháng 4");

  const ChoiceLabel(this.label);
  final String label;
}

final dataset = [
  {
    "name": "30A-123.56",
  },
  {
    "name": "30A-123.45",
  },
  {
    "name": "30A-123.15",
  },
  {
    "name": "30A-123.34",
  },
  {
    "name": "30A-133.45",
  },
  {
    "name": "30A-523.45",
  },
  {
    "name": "30A-163.45",
  },
];

class _StatisticsScreenState extends State<StatisticsScreen> {
  int? chosenIndex;
  List<Map<String, String>> _filteredDataset = [];
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _filteredDataset = List.from(dataset);
    _searchController.addListener(_searchDataset);
    chosenIndex = dataset.indexWhere(
        (element) => element['name'] == widget.selectedLicensePlate);
    if (chosenIndex == -1) chosenIndex = 0;
  }

  // search
  void _searchDataset() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDataset = dataset.where((e) {
        final name = e['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
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
                  const Center(
                    child: Text(
                      "Chọn biển số ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
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
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _filteredDataset.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          shape: const Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(_filteredDataset[index]["name"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          onTap: () {
                            setState(() {
                              chosenIndex = dataset.indexWhere((element) =>
                                  element["name"] ==
                                  _filteredDataset[index]["name"]);
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        //physics: const NeverScrollableScrollPhysics(),
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
                          Text(
                            "${dataset[chosenIndex!]["name"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        selectedTrailingIcon: const Icon(Icons.expand_less),
                        trailingIcon: const Icon(Icons.expand_more),
                        menuStyle: MenuStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.white),
                          surfaceTintColor:
                              const MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        initialSelection: ChoiceLabel.all.name,
                        onSelected: (value) {
                          // TODO: Implement action
                          DoNothingAction();
                        },
                        dropdownMenuEntries: ChoiceLabel.values
                            .map((e) => DropdownMenuEntry(
                                value: e.name, label: e.label))
                            .toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Từ ${DateFormat("dd/MM/yyyy").format(
                          DateTime.now().subtract(const Duration(days: 30)),
                        )} - ${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
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
                      child: const MyBarGraph(gasolineTotal: gasolineTotal))
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
