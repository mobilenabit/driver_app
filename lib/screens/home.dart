import 'package:driver_app/components/nav__bar.dart';
import 'package:driver_app/screens/gas_station.dart';
import 'package:driver_app/screens/history.dart';
import 'package:driver_app/screens/map.dart';
import 'package:driver_app/screens/qr_result.dart';
import 'package:driver_app/screens/scan_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/screens/info.dart';
import 'package:driver_app/screens/settings.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../core/api_client.dart';
import '../core/secure_store.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: InfoScreen(),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/home_selected.svg'),
            inactiveIcon: SvgPicture.asset('assets/icons/home.svg'),
            title: "Trang chủ",
            activeForegroundColor: const Color(0xFFFF8181),
            inactiveForegroundColor: const Color(0xFF161719),
          ),
        ),
        PersistentTabConfig(
          screen: MapScreen(),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/map_selected.svg'),
            inactiveIcon: SvgPicture.asset('assets/icons/map.svg'),
            title: "Bản đồ",
            activeForegroundColor: const Color(0xFFFF8181),
            inactiveForegroundColor: const Color(0xFF161719),
          ),
        ),
        PersistentTabConfig(
          screen: ScanQrScreen(userData: {}),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/qr.svg'),
          ),
        ),
        PersistentTabConfig(
          screen: HistoryScreen(
           
          ),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/history_selected.svg'),
            inactiveIcon: SvgPicture.asset('assets/icons/history.svg'),
            title: "Lịch sử",
            activeForegroundColor: const Color(0xFFFF8181),
            inactiveForegroundColor: const Color(0xFF161719),
          ),
        ),
        PersistentTabConfig(
          screen: SettingsScreen(
            userData: {},
          ),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/user_selected.svg'),
            inactiveIcon: SvgPicture.asset('assets/icons/user.svg'),
            title: "Tài khoản",
            activeForegroundColor: const Color(0xFFFF8181),
            inactiveForegroundColor: const Color(0xFF161719),
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => PetronetNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Color(0xFFFCFCFF),
        ),
      ),
    );
  }
}
