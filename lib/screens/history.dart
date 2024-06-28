import 'package:driver_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class HistoryScreen extends StatefulWidget {
  final String selectedLicensePlate;
  const HistoryScreen({super.key, required this.selectedLicensePlate});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final List<History1> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      History1(
          numberLicense: widget.selectedLicensePlate,
          fuel: 'Xăng RON 95',
          address: 'CHXD Xa La',
          amount: 32,
          hours: '16:30',
          date: '19/06/2024',
          money: 250000),
      History1(
          numberLicense: widget.selectedLicensePlate,
          fuel: 'Xăng RON 92',
          address: 'CHXD Xa La',
          amount: 6,
          hours: '20:00',
          date: '19/06/2024',
          money: 123000),
      History1(
          numberLicense: widget.selectedLicensePlate,
          fuel: 'Xăng RON 92',
          address: 'CHXD Xa La',
          amount: 50,
          hours: '06:30',
          date: '20/06/2024',
          money: 54600),
    ];
  }

  // Format type of number
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  // start and end DateTime
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  // Custom date picker
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Theme(
              data: ThemeData(
                colorScheme: ColorScheme.light(
                  primary: Color.fromRGBO(244, 129, 32, 1), // selection color
                  onPrimary: Colors.white, // text color for selected text
                  onSurface: Colors.black, // default text color
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CalendarDatePicker(
                      initialDate: isStart ? _startDate : _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      onDateChanged: (DateTime date) {
                        Navigator.pop(context, date);
                      },
                      selectableDayPredicate: (DateTime date) => true,
                      currentDate: DateTime.now(),
                      initialCalendarMode: DatePickerMode.day,
                    ),
                  ),
                ],
              ),
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

  // Filter items in list by date picker
  List<History1> get _filteredItems {
    return _items.where((item) {
      DateTime itemDate = DateFormat('dd/MM/yyyy').parse(item.date);
      return itemDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          itemDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 245, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 245, 1),
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Hoạt động',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 17, top: 18),
            child: Text(
              'Truy vấn lịch sử giao dịch',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Pick date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.413,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color.fromRGBO(255, 199, 9, 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 7, bottom: 2),
                              child: Text(
                                'Từ ngày',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(244, 129, 32, 1),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 7),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_startDate),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 7.5),
                          child: SvgPicture.asset('assets/icons/calender.svg'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.413,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color.fromRGBO(255, 199, 9, 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 7, bottom: 2),
                              child: Text(
                                'Đến ngày',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(244, 129, 32, 1),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 7),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_endDate),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 7.5),
                          child: SvgPicture.asset('assets/icons/calender.svg'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // List of history
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];

                //check date is similar to show one time
                bool showHeader = true;
                if (index > 0 && _filteredItems[index - 1].date == item.date) {
                  showHeader = false;
                }

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      // Date header
                      if (showHeader)
                        Container(
                          height: 35,
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 247, 172, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  item.date,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Content
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 8,
                              color: const Color.fromRGBO(0, 0, 0, 0.08),
                            ),
                          ],
                        ),
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.fuel,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(' - '),
                                        Text(
                                          '${currencyFormat.format(item.amount)}lít',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(' - '),
                                        Text(
                                          '${currencyFormat.format(item.money)}₫',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  244, 129, 32, 1)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      item.hours,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromRGBO(130, 134, 158, 1),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  item.address,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(130, 134, 158, 1),
                                  ),
                                ),
                              ),
                              Text(
                                'Biển số xe: ${item.numberLicense}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(130, 134, 158, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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

class History1 {
  final String numberLicense;
  final String fuel;
  final double money;
  final String address;
  final double amount;
  final String hours;
  final String date;

  History1({
    required this.numberLicense,
    required this.fuel,
    required this.address,
    required this.amount,
    required this.hours,
    required this.date,
    required this.money,
  });
}
