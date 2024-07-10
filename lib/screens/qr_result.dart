import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QrResultScreen extends StatefulWidget {
  final String code;
  final Map<String, dynamic>? userData;

  const QrResultScreen(
      {super.key,
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Thông tin mã QR',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 252, 245, 1),
                Color.fromRGBO(255, 244, 219, 1),
              ],
              stops: [29 / 100, 100 / 100],
            ),
          ),
          child: Center(
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
                  margin: const EdgeInsets.symmetric(horizontal: 15),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cột bơm',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(130, 134, 158, 1),
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
                      ),
                     const  Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vòi bơm',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(130, 134, 158, 1),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Số tiền',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(130, 134, 158, 1),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Số lít',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(130, 134, 158, 1),
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Thời gian',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color.fromRGBO(130, 134, 158, 1),
                            ),
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                            style:const TextStyle(
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
        ));
  }
}
