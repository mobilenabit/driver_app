import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QrResultScreen extends StatefulWidget {
  final String code;
  final Function() closeScreen;
  final Map<String, dynamic>? userData;

  const QrResultScreen(
      {super.key,
      required this.closeScreen,
      required this.code,
      required this.userData});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

// Format type of number
final NumberFormat currentFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

class _QrResultScreenState extends State<QrResultScreen> {
  // set avatar
  Widget _getAvatarWidget() {
    if (widget.userData?['data']['avatar'] != null &&
        widget.userData?['data']['avatar'].isNotEmpty) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              widget.userData?['data']['avatar'],
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const Icon(Icons.account_circle, size: 100);
    }
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Thông tin mã QR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                top: 60,
                bottom: 25,
                right: 15,
              ),
              height: size.height * 0.4,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loại nhiên liệu',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(130, 134, 158, 1),
                          ),
                        ),
                        Text(
                          'Xăng RON 95',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF313442),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cột bơm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF82869E),
                        ),
                      ),
                      Text(
                        '2',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(49, 52, 66, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vòi bơm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF82869E),
                        ),
                      ),
                      Text(
                        '2',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(49, 52, 66, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số tiền',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF82869E),
                        ),
                      ),
                      Text(
                        '${currentFormat.format(200000)}₫',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(49, 52, 66, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số lít',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF82869E),
                        ),
                      ),
                      Text(
                        '${currentFormat.format(32)}lít',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(49, 52, 66, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const  Text(
                        'Thời gian',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF82869E),
                        ),
                      ),
                      Text(
                        '${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(49, 52, 66, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -50,
              child: _getAvatarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
