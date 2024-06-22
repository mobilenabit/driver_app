import 'package:driver_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String selectedLicensePlate;
  const HistoryScreen({super.key, required this.selectedLicensePlate});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final List<History> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 19/06/2024',
        status: 'Thanh toán thành công',
        money: 600000,
        fuel: 'RON 95',
      ),
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 1/06/2024',
        status: 'Thanh toán thất bại',
        money: 6000000,
        fuel: 'RON 92',
      ),
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 19/06/2024',
        status: 'Thanh toán thất bại',
        money: 6000000,
        fuel: 'RON 92',
      ),
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 19/06/2024',
        status: 'Thanh toán thành công',
        money: 600000,
        fuel: 'RON 95',
      ),
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 19/06/2024',
        status: 'Thanh toán thành công',
        money: 600000,
        fuel: 'RON 95',
      ),
      History(
        numberLicense: widget.selectedLicensePlate,
        amount: 32,
        pump: 1,
        pumpLog: 2,
        dateTime: '16:20 - 19/06/2024',
        status: 'Thanh toán thành công',
        money: 600000,
        fuel: 'RON 95',
      ),
    ];
  }

  // Format type of number
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  // Date picker
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('vi', 'VN'), // Set locale to Vietnamese
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

  // Filter items in list by date picker
  List<History> get _filteredItems {
    return _items.where((item) {
      DateTime itemDate = DateFormat('HH:mm - dd/MM/yyyy').parse(item.dateTime);
      return itemDate.isAfter(_startDate) && itemDate.isBefore(_endDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 243, 247, 1),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(
                    selectedLicensePlate: widget.selectedLicensePlate),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Hoạt động',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Truy vấn lịch sử giao dịch',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.35,
                height: size.height * 0.06,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Từ ngày',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(130, 134, 158, 1),
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_startDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => _selectDate(context, true),
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.18,
              ),
              Container(
                width: size.width * 0.35,
                height: size.height * 0.06,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đến ngày',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(130, 134, 158, 1),
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_endDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => _selectDate(context, false),
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 0.25,
                  ),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${currencyFormat.format(item.money)}₫',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Text(' - '),
                                  Text(
                                    item.fuel,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                'Biển số xe: ${item.numberLicense}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Số lít: ${item.amount}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Cột bơm: ${item.pump}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Vòi bơm: ${item.pumpLog}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                item.dateTime,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 134, 158, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: item.status == 'Thanh toán thành công'
                                  ? const Color.fromRGBO(197, 255, 196, 0.36)
                                      .withOpacity(0.5)
                                  : const Color.fromRGBO(255, 196, 207, 0.36)
                                      .withOpacity(0.5),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: item.status == 'Thanh toán thành công'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class History {
  final String numberLicense;
  final double amount;
  final int pump;
  final int pumpLog;
  final String status;
  final double money;
  final String fuel;
  final String dateTime;

  History({
    required this.amount,
    required this.dateTime,
    required this.fuel,
    required this.money,
    required this.numberLicense,
    required this.pump,
    required this.pumpLog,
    required this.status,
  });
}
