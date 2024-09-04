import 'package:driver_app/core/secure_store.dart';
import 'package:driver_app/core/user_data.dart';
import 'package:driver_app/screens/change_password.dart';
import 'package:driver_app/screens/home.dart';
import 'package:driver_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool savePassword = false;
  bool isBiometricAvailable = false;
  final LocalAuthentication localAuth = LocalAuthentication();

  void _checkBiometric() async {
    isBiometricAvailable = await localAuth.canCheckBiometrics;

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    setState(() {
      isBiometricAvailable = availableBiometrics.isNotEmpty;
    });
  }

  void _notifyNoBiometric() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thông báo"),
          content: const Text(
              "Thiết bị không hỗ trợ xác thực bằng vân tay hoặc FaceID"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _handleSavePassword() async {
    await SecureStorage()
        .writeSecureData("save_password", savePassword.toString());
  }

  void _handleSavePasswordState() async {
    final savePasswordState =
        await SecureStorage().readSecureData("save_password");
    if (savePasswordState != null) {
      setState(() {
        savePassword = savePasswordState == "true";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
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
            color: Colors.white,
            size: 18,
          ),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        actions: [
          // ignore: deprecated_member_use
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                // ignore: deprecated_member_use
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 25,
          top: 40,
          right: 25,
        ),
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cài đặt tài khoản",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF91919F),
                ),
              ),
              SwitchListTile(
                value: savePassword,
                onChanged: (value) {
                  if (!isBiometricAvailable) {
                    _notifyNoBiometric();
                  } else {
                    setState(() {
                      savePassword = value;
                    });
                    _handleSavePassword();
                  }
                },
                title: const Text(
                  "Đăng nhập bằng sinh trắc học",
                  style: TextStyle(),
                ),
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Đổi mật khẩu"),
                trailing: const Icon(LucideIcons.lock),
                onTap: () {
                  
                  final userData = context.read<UserDataModel>().value;
                  pushScreenWithoutNavBar(
                    context,
                    ChangePasswordScreen(
                      userData: userData!,
                      changePassword: true,
                    ),
                  );
                },
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 16),
              const Text(
                "Hỗ trợ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF91919F),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Về ứng dụng"),
                trailing: const Icon(LucideIcons.chevron_right),
                onTap: () {},
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    color: Color.fromRGBO(255, 129, 129, 1),
                  ),
                ),
                trailing: const Icon(
                  LucideIcons.log_out,
                  color: Color.fromRGBO(255, 129, 129, 1),
                ),
                onTap: () {
                  pushScreenWithoutNavBar(
                    context,
                    const LoginScreen(),
                  );
                },
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
