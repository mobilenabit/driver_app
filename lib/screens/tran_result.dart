import 'package:dotted_line/dotted_line.dart';
import 'package:driver_app/components/ticket_cliper.dart';
import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TranResultScreen extends StatefulWidget {
  final int status;
  final int code;
  final double amount;
  final String hours;
  final String date;
  final double money;
  final String vehicleCode;
  final double unitPrice;
  final String productName;
  final String licensePlate;
  final int branchId;

  const TranResultScreen(
      {super.key,
      required this.amount,
      required this.code,
      required this.date,
      required this.hours,
      required this.money,
      required this.productName,
      required this.unitPrice,
      required this.vehicleCode,
      required this.status,
      required this.licensePlate,
      required this.branchId});

  @override
  State<TranResultScreen> createState() => _TranResultScreenState();
}

class _TranResultScreenState extends State<TranResultScreen> {
  Map<String, dynamic>? orgUnit;
  void getOrgUnit() async {
    try {
      final response = await apiClient.getCompany(widget.branchId);
      print(response);
      if (response["success"]) {
        setState(() {
          orgUnit = response["data"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getOrgUnit();
    print(orgUnit);
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Chi tiết giao dịch',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(238, 239, 248, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        widget.status == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/transaction_success.png',
                                    scale: 2.0,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Thanh toán thành công",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(26, 159, 65, 1),
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat.currency(
                                      decimalDigits: 0,
                                      symbol: "₫",
                                      customPattern: "###,###",
                                    ).format(widget.money)} ₫',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/transaction_failure.png',
                                    scale: 2.0,
                                  ),
                                  const Text(
                                    "Thanh toán không thành công",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(236, 139, 135, 1),
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat.currency(
                                      decimalDigits: 0,
                                      symbol: "₫",
                                      customPattern: "###,###",
                                    ).format(widget.money)} ₫',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width * 0.86,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      15,
                                      25,
                                      15,
                                      10,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Loại nhiên liệu",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF82869E),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8F8FC),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            children: [
                                              // SvgPicture.asset(
                                              //   'assets/icons/gasType.svg',
                                              //   width: 44,
                                              //   height: 44,
                                              // ),
                                              widget.productName.contains("DO")
                                                  ? Image.asset(
                                                      "assets/images/pump_do.png",
                                                      width: 44,
                                                      height: 44,
                                                    )
                                                  : widget.productName
                                                          .contains("92")
                                                      ? Image.asset(
                                                          "assets/images/pump_r92.png",
                                                          width: 44,
                                                          height: 44,
                                                        )
                                                      : widget.productName
                                                              .contains("95")
                                                          ? Image.asset(
                                                              "assets/images/pump_r95.png",
                                                              width: 44,
                                                              height: 44,
                                                            )
                                                          : Image.asset(
                                                              "assets/images/pump_do.png",
                                                              width: 44,
                                                              height: 44,
                                                            ),
                                              SizedBox(
                                                  width: size.width * 0.025),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.productName,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${NumberFormat.currency(
                                                      decimalDigits: 0,
                                                      symbol: "₫",
                                                      customPattern: "###,###",
                                                    ).format(widget.unitPrice)} ₫',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xFF82869E),
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
                                  ClipPath(
                                    clipper: CustomTicketShape(),
                                    child: Container(
                                      height: size.height * 0.04,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: DottedLine(
                                          lineLength: size.width * 0.7,
                                          dashColor:
                                              Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      15,
                                      10,
                                      25,
                                      15,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Thời gian",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              '${widget.hours}-${widget.date}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Mã giao dịch",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              widget.code.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Biển số xe",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              widget.licensePlate,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        // const Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(
                                        //       "Vòi bơm",
                                        //       style: TextStyle(
                                        //         fontWeight: FontWeight.w400,
                                        //         fontSize: 13,
                                        //       ),
                                        //     ),
                                        //     Text(
                                        //       '2',
                                        //       style: TextStyle(
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 13,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(height: size.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Số lượng",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              '${NumberFormat.currency(
                                                decimalDigits: 0,
                                                customPattern: "###,###",
                                              ).format(widget.amount)} lít',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Cửa hàng",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              orgUnit?["shortName"],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Địa chỉ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                orgUnit?["address"],
                                                textAlign: TextAlign.right,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
