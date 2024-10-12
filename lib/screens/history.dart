import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:driver_app/screens/tran_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> _items = [];
  bool _isLoading = false;
  String currentLicensePlate = "";

  @override
  void initState() {
    currentLicensePlate =
        context.read<LicensePlateModel>().value?["vehicle"]["vehicleCode"];
    super.initState();
    getHistory();

    _sortDate();
    _sortTime();
  }

  // Sort date DESC
  void _sortDate() {
    _items.sort(
      (a, b) => DateFormat('dd/MM/yyyy').parse(b.date).compareTo(
            DateFormat('dd/MM/yyyy').parse(a.date),
          ),
    );
  }

  // sort time DESC
  void _sortTime() {
    _items.sort((a, b) => DateFormat('HH:mm').parse(b.hours).compareTo(
          DateFormat('HH:mm').parse(a.hours),
        ));
  }

  // Format type of number
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  // Start and end DateTime
  DateTime _startDate = DateTime.now().subtract(
    const Duration(days: 7),
  );
  DateTime _endDate = DateTime.now();

  // list date
  final List<String> date = [
    '7 ngày',
    '15 ngày',
    '30 ngày',
  ];

  Future<void> getHistory() async {
    var licensePlate = context.read<LicensePlateModel>().value;
    setState(() {
      _isLoading = true;
      _items.clear();
    });

    try {
      print(_startDate);
      print(_endDate);
      var response = await apiClient.getHistory(_startDate, _endDate,
          licensePlate?["driverId"], licensePlate?["vehicleId"]);
      print(response);
      if (response["success"]) {
        for (var item in response["data"]) {
          // print("Status: ${item["status"].runtimeType}");
          // print("Code: ${item["id"].runtimeType}");
          // print(item["trpr"][0]["qty"].runtimeType);
          // print("Amount: ${item["trpr"][0]["qty"].runtimeType}");
          // print("Hours: ${item["modified"].runtimeType}");
          // print("Money: ${item["trpr"][0]["tienHang"].runtimeType}");
          // print("UnitPrice: ${item["trpr"][0]["unitPrice"].runtimeType}");
          // print("ProductName: ${item["trpr"][0]["productName"].runtimeType}");
          setState(() {
            _items.add(History(
              status: item["status"],
              code: item["id"],
              amount: item["trpr"][0]["qty"],
              hours:
                  DateFormat("HH:mm").format(DateTime.parse(item["modified"])),
              date: DateFormat("dd/MM/yyyy")
                  .format(DateTime.parse(item["modified"])),
              money: item["trpr"][0]["tienHang"],
              vehicleCode: licensePlate?["vehicle"]["vehicleCode"],
              unitPrice: item["trpr"][0]["unitPrice"],
              productName: item["trpr"][0]["productName"],
              branchId: item["branchId"],
            ));
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to get history");
    }
    setState(() {
      _isLoading = false;
    });
    print(_isLoading);
  }

  int? _dateSelected;

  // Custom date picker
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 1,
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Column(
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      firstDate: DateTime.now().subtract(
                        const Duration(
                          days: 30,
                        ),
                      ),
                      lastDate: DateTime.now(),
                      customModePickerIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(99, 96, 255, 1),
                        size: 25,
                      ),
                      dayTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      selectedDayHighlightColor:
                          const Color.fromRGBO(99, 96, 255, 1),
                      lastMonthIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(99, 96, 255, 1),
                        size: 18,
                      ),
                      nextMonthIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(99, 96, 255, 1),
                        size: 18,
                      ),
                      disableMonthPicker: true,
                      controlsTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      weekdayLabelTextStyle: const TextStyle(
                        color: Color(0x4D3C3C43),
                        fontSize: 16,
                      ),
                    ),
                    value: [
                      isStart ? _startDate : _endDate,
                    ],
                    onValueChanged: (value) {
                      setState(() {
                        if (isStart) {
                          _startDate =
                              value[0]!.copyWith(hour: 0, minute: 0, second: 0);
                        } else {
                          _endDate = value[0]!.copyWith(hour: 0, minute: 0);
                        }
                        getHistory();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Group items by date
  Map<String, List<History>> get _groupedItems {
    Map<String, List<History>> groupedItems = {};

    for (var item in _filteredItems) {
      if (groupedItems[item.date] == null) {
        groupedItems[item.date] = [];
      }
      groupedItems[item.date]!.add(item);
    }

    return groupedItems;
  }

  // Filter items in list by date picker
  List<History> get _filteredItems {
    return _items.where((item) {
      DateTime itemDate = DateFormat('dd/MM/yyyy').parse(item.date);
      return itemDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          itemDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   context.watch<LicensePlateModel>().licensePlate;
  //   getHistory();
  //   print(_items);
  // }

  @override
  Widget build(BuildContext context) {
    // watch the licensePlate for changes. getHistory() will be called when the licensePlate changes

    var color = const Color.fromRGBO(99, 96, 255, 1);

    return Consumer2<UserDataModel, LicensePlateModel>(
      builder: (context, userData, licensePlate, child) => Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: color,
          //  toolbarHeight: 80,
          title: const Text(
            'Lịch sử giao dịch',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(241, 241, 250, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pick date
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 35,
                            left: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            'Từ ngày',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 12,
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_startDate),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 14.5,
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/icons/calender.svg',
                                      height: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                            top: 35,
                            bottom: 5,
                          ),
                          child: Text(
                            'Đến ngày',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                          top: 12,
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_endDate),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 14.5,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/calender.svg',
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Text(
                  'Hệ thống hỗ trợ truy vấn lịch sử giao dịch trong vòng 30 ngày gần nhất',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(145, 145, 159, 1),
                  ),
                ),
              ),

              // choose days
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: date.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSelected = _dateSelected == index;
                    return TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _dateSelected = isSelected ? null : index;
                            if (date[index] == '7 ngày') {
                              _endDate = DateTime.now();
                              _startDate = _endDate.subtract(
                                const Duration(days: 7),
                              );
                              getHistory();
                            } else if (date[index] == '15 ngày') {
                              _endDate = DateTime.now();
                              _startDate = _endDate.subtract(
                                const Duration(days: 15),
                              );
                              getHistory();
                            } else {
                              _endDate = DateTime.now();
                              _startDate = _endDate.subtract(
                                const Duration(days: 30),
                              );
                              getHistory();
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? color
                                : const Color.fromRGBO(208, 213, 221, 1),
                          ),
                          color: isSelected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          child: Text(
                            date[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : const Color.fromRGBO(52, 64, 85, 1),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: _filteredItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Image.asset(
                                      'assets/images/intent.png',
                                      scale: 4,
                                    ),
                                  ),
                                  Text(
                                    'Không có phát sinh giao dịch',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    'trong khoảng thời gian này',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _groupedItems.keys.length,
                              itemBuilder: (context, index) {
                                String date =
                                    _groupedItems.keys.elementAt(index);
                                List<History> historyList =
                                    _groupedItems[date]!;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Date header
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                145, 145, 159, 1),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),

                                      // Content
                                      Column(
                                        children: historyList.map((item) {
                                          return GestureDetector(
                                            onTap: () {
                                              pushScreenWithoutNavBar(
                                                context,
                                                TranResultScreen(
                                                    amount: item.amount,
                                                    code: item.code,
                                                    date: item.date,
                                                    hours: item.hours,
                                                    money: item.money,
                                                    status: item.status,
                                                    vehicleCode:
                                                        item.vehicleCode,
                                                    unitPrice: item.unitPrice,
                                                    productName:
                                                        item.productName,
                                                    licensePlate: licensePlate
                                                            .licensePlate ??
                                                        "",
                                                    branchId: item.branchId),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Thời gian: ${item.hours}',
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      145,
                                                                      145,
                                                                      159,
                                                                      1),
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: item.status ==
                                                                    1
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    219,
                                                                    255,
                                                                    225,
                                                                    1)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    255,
                                                                    219,
                                                                    219,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: Text(
                                                            item.status == 1
                                                                ? "Thành công"
                                                                : "Đã huỷ",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: item.status ==
                                                                      'Thành công'
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      76,
                                                                      217,
                                                                      100,
                                                                      1)
                                                                  : const Color
                                                                      .fromRGBO(
                                                                      255,
                                                                      99,
                                                                      99,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.003,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Mã giao dịch: ${item.code}',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              'Chi tiết',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          145,
                                                                          145,
                                                                          159,
                                                                          1),
                                                                  fontSize: 15),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Icon(
                                                              LucideIcons
                                                                  .chevron_right,
                                                              size: 18,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      145,
                                                                      145,
                                                                      159,
                                                                      1),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.003,
                                                    ),
                                                    Text(
                                                      'Số lượng: ${currencyFormat.format(item.amount)}lít',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.003,
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.003,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Số tiền: ',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '${currencyFormat.format(item.money)}₫',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: color,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
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

class History {
  final int status;
  final int code;
  final double amount;
  final String hours;
  final String date;
  final double money;
  final String vehicleCode;
  final double unitPrice;
  final String productName;
  final int branchId;

  History({
    required this.amount,
    required this.code,
    required this.date,
    required this.hours,
    required this.money,
    required this.status,
    required this.vehicleCode,
    required this.unitPrice,
    required this.productName,
    required this.branchId,
  });
}
