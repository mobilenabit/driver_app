import "package:driver_app/screens/history.dart";
import "package:driver_app/screens/info.dart";
import "package:driver_app/screens/settings.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../core/api_client.dart";
import "../core/secure_store.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
          backgroundColor: const Color(0xFFFFC709),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: [
              NavigationDestination(
                selectedIcon: SvgPicture.asset("assets/icons/logo.svg"),
                icon: SvgPicture.asset("assets/icons/logo.svg"),
                label: "Trang chủ",
              ),
              const NavigationDestination(
                selectedIcon: Icon(
                  Icons.history,
                  color: Color(0xFF82869E),
                ),
                icon: Icon(
                  Icons.history_outlined,
                  color: Color(0xFF82869E),
                ),
                label: "Lịch sử",
              ),
              NavigationDestination(
                selectedIcon:
                    SvgPicture.asset("assets/icons/settings_filled.svg"),
                icon: SvgPicture.asset("assets/icons/settings.svg"),
                label: "Cài đặt",
              ),
            ],
          ),
          body: <Widget>[
           // InfoScreen(),
            HistoryScreen(),
            SettingsScreen(userData: snapshot.data),
          ][currentPageIndex],
        );
      },
    );
  }
}
