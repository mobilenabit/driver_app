import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:intl/intl.dart";

import "../core/api_client.dart";
import "../core/helpers.dart";

class PumpCard extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final int pumpId;
  final String pumpName;
  final String productName;
  final Map<String, dynamic>? pumpLogs;

  const PumpCard({
    super.key,
    required this.userData,
    required this.pumpId,
    required this.pumpName,
    required this.productName,
    required this.pumpLogs,
  });

  @override
  State<PumpCard> createState() => _PumpCardState();
}

class _PumpCardState extends State<PumpCard> {
  final bool _isRefreshing = false;
  Map<String, dynamic>? _pumpLogs;

  void _handleRefresh(int branchId, int pumpId) async {
    var pumpLogs = await ApiClient()
        .getPumpLogs(widget.userData?["data"]["branchId"], pumpId.toString());

    if (kDebugMode && pumpLogs["data"] != null) {
      Fluttertoast.showToast(msg: "Loaded ${pumpLogs["data"].length} records.");
    }

    setState(() {
      _pumpLogs = pumpLogs;
    });
  }

  void _handlePump(int pumpId, String pumpName, String productName,
      Map<String, dynamic>? pumpLogs) {
    if (kDebugMode) {
      print("_handlePump: $pumpLogs");
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.6,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 24,
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            pumpName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1D29),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF82869E),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        iconSize: 24,
                        icon: SvgPicture.asset(
                          "assets/icons/refresh.svg",
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0072BC),
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          _handleRefresh(
                              widget.userData?["data"]["branchId"], pumpId);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (_isRefreshing) const CircularProgressIndicator(),
                if (_pumpLogs?["data"] == null || _pumpLogs?["data"].isEmpty)
                  const Center(
                    child: Text("Không có dữ liệu log bơm."),
                  ),
                if (_pumpLogs?["data"] != null && !_isRefreshing)
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.pumpLogs?["data"].length,
                      itemBuilder: (BuildContext context, int index) {
                        var log = widget.pumpLogs?["data"][index];
                        var time = DateFormat("HH:mm:ss - dd/MM/yyyy")
                            .format(DateTime.parse(log["endFuelingTime"]));

                        return Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shadowColor: Colors.transparent,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            leading: Image(
                              image: getProductImageFromString(productName),
                              width: 44,
                              height: 44,
                            ),
                            trailing: Container(
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
                            title: Text(
                              NumberFormat.simpleCurrency(
                                locale: "vi-VN",
                                decimalDigits: 0,
                              ).format(log["amount"]),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B1D29),
                              ),
                            ),
                            subtitle: Text(
                              time,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF82869E),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _pumpLogs = widget.pumpLogs;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("PumpCard: $_pumpLogs");
    }
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (widget.pumpLogs?["data"] == null) {
          Fluttertoast.showToast(
            msg: "Có lỗi trong lúc lấy dữ liệu log bơm.",
          );
        }
        _handlePump(
            widget.pumpId, widget.pumpName, widget.productName, _pumpLogs);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: getProductImageFromString(widget.productName),
                  width: 44,
                  height: 44,
                ),
                SizedBox(width: size.width * 0.025),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pumpName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF82869E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                if (widget.pumpLogs?["data"] != null)
                  Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE43434),
                    ),
                    child: Center(
                      child: Text(
                        widget.pumpLogs?["data"].length.toString() ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: size.width * 0.025),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
