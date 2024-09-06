import 'package:driver_app/components/nav__bar.dart';
import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/screens/account.dart';
import 'package:driver_app/screens/history.dart';
import 'package:driver_app/screens/map.dart';
import 'package:driver_app/screens/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver_app/screens/info.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserDataModel()..loadUserData(),
      child: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: const InfoScreen(),
            item: ItemConfig(
              icon: SvgPicture.asset('assets/icons/home_selected.svg'),
              inactiveIcon: SvgPicture.asset('assets/icons/home.svg'),
              title: "Trang chủ",
              activeForegroundColor: const Color(0xFFFF8181),
              inactiveForegroundColor: const Color(0xFF161719),
            ),
          ),
          PersistentTabConfig(
            screen: const MapScreen2(),
            item: ItemConfig(
              icon: SvgPicture.asset('assets/icons/map_selected.svg'),
              inactiveIcon: SvgPicture.asset('assets/icons/map.svg'),
              title: "Bản đồ",
              activeForegroundColor: const Color(0xFFFF8181),
              inactiveForegroundColor: const Color(0xFF161719),
            ),
          ),
          PersistentTabConfig(
            screen: const QrScreen(),
            item: ItemConfig(
              icon: SvgPicture.asset('assets/icons/qr.svg'),
            ),
          ),
          PersistentTabConfig(
            screen: const HistoryScreen(),
            item: ItemConfig(
              icon: SvgPicture.asset('assets/icons/history_selected.svg'),
              inactiveIcon: SvgPicture.asset('assets/icons/history.svg'),
              title: "Lịch sử",
              activeForegroundColor: const Color(0xFFFF8181),
              inactiveForegroundColor: const Color(0xFF161719),
            ),
          ),
          PersistentTabConfig(
            screen: const AccountScreen(),
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
      ),
    );
  }
}
