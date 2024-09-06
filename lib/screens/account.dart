import 'dart:io';

import 'package:driver_app/screens/license_plate.dart';
import 'package:driver_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import '../../core/user_data.dart';

class AccountScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AccountScreen({
    super.key,
    this.userData,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    SvgPicture.asset('assets/icons/person.svg'),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Thư viện',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _pickImageFromCamera();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      LucideIcons.camera,
                      color: Color.fromRGBO(99, 96, 255, 1),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Chụp ảnh',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
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

  // Choose image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {});
    }
  }

  // Choose image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {});
    }
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

    return Consumer<UserDataModel>(
      builder: (context, userData, child) => Scaffold(
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
          foregroundColor: const Color(0xFFFCFCFF),
          backgroundColor: const Color(0xFF6360FF),
          surfaceTintColor: const Color(0xFF6360FF),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 96),
                child: Column(
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
                            image: NetworkImage(
                              userData.value?["avatar"],
                            ),
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
                    const SizedBox(height: 20),
                    Text(
                      userData.value?["displayName"] ?? "Unknown User",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFCFCFF),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1,
                  padding: const EdgeInsets.only(
                    top: 50,
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
                    scrollDirection: Axis.vertical,
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
                                  child: Column(
                                    children: [
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
                                        child: Text(
                                          '16.000.000đ',
                                          style: style2,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                          'Hạn mức từng giao dịch',
                                          style: style1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 15, top: 15),
                                        child: Text(
                                          '1.500.000đ',
                                          style: style2,
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
                                'DVVT Thái Hải',
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
                                '245 Phùng Hưng, Hà Đông',
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
                              Text(
                                'PVOIL Hà Nội',
                                style: title,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: showModalBottom,
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
                                    SvgPicture.asset('assets/icons/image.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Thay đổi ảnh',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pushWithoutNavBar(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LicensePlateScreen(),
                                  ),
                                );
                              },
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
