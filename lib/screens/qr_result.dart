import 'package:dotted_line/dotted_line.dart';
import 'package:driver_app/components/ticket_cliper.dart';
import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:driver_app/models/product_names.dart';
import 'package:driver_app/screens/transaction_fail.dart';
import 'package:driver_app/screens/transaction_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QrResultScreen extends StatefulWidget {
  final int orderId;
  final String vehiclePlate;
  const QrResultScreen(
      {super.key, required this.orderId, required this.vehiclePlate});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
  Map<String, dynamic>? order;
  String? customerName;
  String? location;

  Future<dynamic> submitOrder(int status) async {
    var response = await apiClient.updateOrderStatus(status, widget.orderId);
    print(response);
    if (response["success"]) {
      return true;
    } else {
      return response;
    }
  }

  Future<Map<String, dynamic>> getLog() async {
    try {
      final response = await apiClient.getLog(widget.orderId);
      if (response["success"]) {
        return response["data"];
      } else {
        return response;
      }
    } catch (e) {
      throw Exception("Failed to load log");
    }
  }

  void getLog2() async {
    try {
      final response = await apiClient.getLog(widget.orderId);
      if (response["success"]) {
        setState(() {
          order = response["data"];
        });
        final response1 =
            await apiClient.getPumpStation(int.parse(order!["nozzleId"]));
        print(response1);
        if (response1["success"]) {
          final response2 =
              await apiClient.getCompany(response1["data"]["branchId"]);
          print(response2);
          if (response2["success"]) {
            setState(() {
              customerName = response2["data"]["shortName"];
              location = response2["data"]["address"];
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to load log");
    }
  }

  void getAddress() async {
    if (order == null) {
      print("Order is null");
    }
    try {
      final response1 =
          await apiClient.getPumpStation(int.parse(order!["nozzleId"]));
      print(response1);
      if (response1["success"]) {
        final response2 =
            await apiClient.getCompany(response1["data"]["branchId"]);
        print(response2);
        if (response2["success"]) {
          setState(() {
            customerName = response2["data"]["shortName"];
            location = response2["data"]["address"];
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to load address");
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.orderId);
    getLog2();
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        automaticallyImplyLeading: false,
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
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width * 0.85,
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
                                              SvgPicture.asset(
                                                'assets/icons/gasType.svg',
                                                width: 44,
                                                height: 44,
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.025),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Xăng E5 RON 92-II',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    future: getLog(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Text(
                                                            "Đang tải...");
                                                      } else {
                                                        return Text(
                                                          "${NumberFormat("###,###").format(snapshot.data?["unitPrice"])}₫",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xFF82869E),
                                                          ),
                                                        );
                                                      }
                                                    },
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
                                            // Text(
                                            //   '20:00 - 19/08/2024',
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.w600,
                                            //     fontSize: 13,
                                            //   ),
                                            // ),
                                            FutureBuilder(
                                                future: getLog(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                        "Đang tải...");
                                                  } else {
                                                    return Text(
                                                      '${DateFormat("HH:mm - dd/MM/yyyy").format(DateTime.now())}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    );
                                                  }
                                                })
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
                                            FutureBuilder(
                                                future: getLog(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                        "Đang tải...");
                                                  } else {
                                                    return Text(
                                                      '${snapshot.data?["id"]}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    );
                                                  }
                                                })
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
                                              widget.vehiclePlate,
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
                                              "Số lượng",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            FutureBuilder(
                                                future: getLog(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                        "Đang tải...");
                                                  } else {
                                                    return Text(
                                                      '${snapshot.data?["volume"]} lít',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    );
                                                  }
                                                })
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
                                              customerName ?? "Đang tải...",
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
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                location ?? "Đang tải...",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.right,
                                                softWrap: true,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.85,
                    margin: const EdgeInsets.symmetric(
                      vertical: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              submitOrder(0);
                              order != null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TransactionFailedResult(
                                          order: order!,
                                          vehicleCode: widget.vehiclePlate,
                                          customerName: customerName!,
                                          location: location!,
                                        ),
                                      ),
                                    )
                                  : DoNothingAction();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color.fromRGBO(191, 200, 210, 1),
                                  strokeAlign: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 10,
                              ),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              submitOrder(2);
                              order != null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TransactionResult(
                                          order: order!,
                                          vehicleCode: widget.vehiclePlate,
                                          customerName: customerName!,
                                          location: location!,
                                        ),
                                      ),
                                    )
                                  : DoNothingAction();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 10,
                              ),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
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
