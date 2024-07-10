import 'package:driver_app/screens/test1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/screens/info.dart';
import 'package:driver_app/screens/settings.dart';

import '../core/api_client.dart';
import '../core/secure_store.dart';

class HomeScreen extends StatefulWidget {
  final String selectedLicensePlate;

  const HomeScreen({super.key, required this.selectedLicensePlate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  Future<Map<String, dynamic>>? _userData;

  @override
  void initState() {
    super.initState();

    _userData = ApiClient().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _userData,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          SecureStorage().writeSecureData("last_logged_in_user_name",
              snapshot.data?["data"]["displayName"]);
          SecureStorage().writeSecureData(
              "last_logged_in_user_avatar", snapshot.data?["data"]["avatar"]);
          SecureStorage().writeSecureData("last_logged_in_user_phone_number",
              snapshot.data?["data"]["phoneNumber"]);
        }
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: <Widget>[
                  InfoScreen(
                    userData: snapshot.data,
                    selectedLicensePlate: widget.selectedLicensePlate,
                  ),
                  Test1(selectedLicensePlate: widget.selectedLicensePlate),
                  SettingsScreen(userData: snapshot.data),
                ][currentPageIndex],
              ),
              if (currentPageIndex != 1)
                Positioned(
                  bottom: size.height * 0.06,
                  left: 16,
                  right: 16,
                  child: _buildFloatingNavBar(),
                ),
            ],
          ),
        );
      },
    );
  }

  // float bottom bar
  Widget _buildFloatingNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icons/home.svg',
              'assets/icons/home_yellow.svg', 'Trang chủ'),
          _buildNavItem(1, 'assets/icons/history.svg',
              'assets/icons/history_yellow.svg', 'Lịch sử'),
          _buildNavItem(2, 'assets/icons/settings.svg',
              'assets/icons/settings_filled.svg', 'Cài đặt'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, String iconPath, String selectedIconPath, String label) {
    bool isSelected = currentPageIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentPageIndex = index;
          });
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? SvgPicture.asset(selectedIconPath)
                  : SvgPicture.asset(iconPath),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
