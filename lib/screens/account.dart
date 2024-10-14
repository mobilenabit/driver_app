import 'dart:convert';
import "dart:typed_data";
import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/driver.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/screens/license_plate.dart';
import 'package:driver_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Map<String, dynamic>> _items = [];
  String selectedLicensePlate = "";
  int? availableCreditLimit;
  int? totalCreditLimit;
  String? address;
  String? customerName;

  Future<void> _selectLicensePlate() async {
    var userData = context.read<UserDataModel>().value;
    final result = await pushReplacementWithoutNavBar(
      context,
      MaterialPageRoute(
        builder: (context) => LicensePlateScreen(userData: userData),
      ),
    );

    if (result != null) {
      setState(() {
        selectedLicensePlate = result;
      });
    }
  }

  // Future<List<Map<String, dynamic>>> fetchUserData() async {
  //   try {
  //     final response = await apiClient.getUserData();
  //     print(response);

  //     if (response['success']) {
  //       print('UserData: ${response["data"]}');

  //       setState(() {
  //         _items = [response["data"]];
  //       });
  //       return _items;
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to load UserData');
  //   }
  // }

  void showModalBottom() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _pickImageFromGallery(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    SvgPicture.asset('assets/icons/gallery.svg'),
                    const SizedBox(width: 20),
                    const Text(
                      'Thư viện',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              MaterialButton(
                onPressed: () {
                  _pickImageFromCamera(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    SvgPicture.asset('assets/icons/cam_account.svg'),
                    const SizedBox(width: 20),
                    const Text(
                      'Chụp ảnh',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final fileName = pickedFile.name;
      final res = await apiClient.uploadImage(bytes, fileName);
      await apiClient.updateImage(_items[0], res["data"]["data"]["id"]);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String fileName = pickedFile.name;
      final res = await apiClient.uploadImage(bytes, fileName);
      await apiClient.updateImage(_items[0], res["data"]["data"]["id"]);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.white,
          title: const Text(
            'Đã gửi yêu cầu thành công',
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(99, 96, 255, 1),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getCreditLimit() async {
    var driverInfo = context.read<LicensePlateModel>().value;
    var customerId = driverInfo?["vehicle"]["customerId"];
    try {
      var res = await apiClient.getCustomer(customerId);
      if (res["success"]) {
        return res["data"];
      }
    } catch (e) {
      return {};
    }
    return {};
  }

  Future<Map<String, dynamic>> getCompany() async {
    var company = context.read<UserDataModel>().value?["branchId"];
    try {
      final response = await ApiClient().getCompany(company);
      if (response["success"]) {
        final response2 =
            await ApiClient().getCompany(response["data"]["idParent"]);
        if (response2["success"]) {
          return response2["data"];
        }
      }
    } catch (e) {
      return {};
    }
    return {};
  }

  void getCustomer() async {
    var driverInfo = context.read<LicensePlateModel>().value;
    try {
      final response =
          await apiClient.getCustomer(driverInfo?["vehicle"]["customerId"]);
      if (response["success"]) {
        setState(() {
          address = response["data"]["address"];
          customerName = response["data"]["customerName"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCreditLimit();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    var title = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    var subTitle = const TextStyle(
      fontSize: 15,
      color: Color.fromRGBO(130, 134, 158, 1),
    );

    var style1 = const TextStyle(
      fontSize: 13,
      color: Color.fromRGBO(145, 145, 159, 1),
    );

    var style2 = const TextStyle(
      fontSize: 15,
      color: Color.fromRGBO(253, 79, 79, 1),
    );

    return Consumer3<UserDataModel, LicensePlateModel, DriverModel>(
      builder: (context, userData, licensePlate, driver, child) => Scaffold(
        backgroundColor: const Color(0xFF6360FF),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                pushScreenWithoutNavBar(
                  context,
                  const SettingsScreen(),
                );
              },
              icon: const Icon(
                LucideIcons.settings,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: const Color(0xFF6360FF),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Stack(
                        children: [
                          if (userData.value?["avatar"] != null &&
                              userData.value?["avatar"].isNotEmpty)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(userData.value?["avatar"]),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          // Positioned(
                          //   bottom: 8,
                          //   right: -1,
                          //   child: SvgPicture.asset(
                          //     'assets/icons/chang_ava.svg',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      driver.value?["driverName"],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: SvgPicture.asset('assets/icons/car.svg'),
                        ),
                        Text(
                          licensePlate.licensePlate ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/phone.svg',
                            width: 13,
                            height: 13,
                          ),
                        ),
                        Text(
                          userData.value?["phoneNumber"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1,
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 25,
                    right: 25,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.all(
                            width: 1,
                            color: const Color.fromRGBO(226, 226, 226, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.5),
                            1: FractionColumnWidth(0.5),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: Text(
                                        'Hạn mức còn lại',
                                        style: style1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 15, top: 15),
                                        child: FutureBuilder(
                                            future: getCreditLimit(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              }
                                              return Text(
                                                '${NumberFormat("###,###").format(snapshot.data?["availableCreditLimit"] ?? 0)} đ',
                                                style: style2,
                                              );
                                            })),
                                  ]),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                        ),
                                        child: Text(
                                          'Hạn mức tổng',
                                          style: style1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 15, top: 15),
                                        child: FutureBuilder(
                                          future: getCreditLimit(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return const Text('Error');
                                            }

                                            return Text(
                                              '${NumberFormat("###,###").format(snapshot.data?["creditLimit"] ?? 0)} đ',
                                              style: style2,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            top: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Công ty',
                                  style: subTitle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                customerName ?? "Không có thông tin",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Địa chỉ',
                                  style: subTitle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                address ?? "Không có thông tin",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 32,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Đơn vị cấp hạn mức',
                                  style: subTitle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              FutureBuilder(
                                future: getCompany(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Text(
                                    snapshot.data?["shortName"] ??
                                        "Không có thông tin",
                                    style: title,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: showPopup,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/bill.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Cấp lại hạn mức',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _selectLicensePlate,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/car.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Đổi xe',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
