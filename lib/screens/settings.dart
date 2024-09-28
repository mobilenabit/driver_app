import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:provider/provider.dart";
import "package:local_auth/local_auth.dart";
import "../../core/secure_store.dart";
import "../../core/user_data.dart";
import "change_password.dart";
import "login.dart";
import "user_info.dart";

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const SettingsScreen({
    super.key,
    this.userData,
  });

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

  void _handleLogout() async {
    await const SecureStorage().deleteSecureData("logged_in");
    var accessToken =
        await const SecureStorage().readSecureData("access_token");
    await const SecureStorage()
        .writeSecureData("held_access_token", accessToken!);
    await const SecureStorage().deleteSecureData("access_token");

    pushScreenWithoutNavBar(
      context,
      const LoginScreen(),
    );
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

  void _handleBiometricAuth() async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
        localizedReason: 'Xác thực sinh trắc học',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  void _handleSavePassword() async {
    await const SecureStorage()
        .writeSecureData("save_password", savePassword.toString());
  }

  void _handleSavePasswordState() async {
    final savePasswordState =
        await const SecureStorage().readSecureData("save_password");
    if (savePasswordState != null) {
      setState(() {
        savePassword = savePasswordState == "true";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleSavePasswordState();
    _checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataModel>(
      builder: (context, userData, child) => Scaffold(
        backgroundColor: const Color(0xFF6360FF),
        appBar: AppBar(
          title: const Text(
            "Cài đặt",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          centerTitle: false,
          foregroundColor: const Color(0xFFFCFCFF),
          backgroundColor: const Color(0xFF6360FF),
          surfaceTintColor: const Color(0xFF6360FF),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 32, bottom: 70),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEFF8),
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
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Thông tin tài khoản"),
                          trailing: const Icon(LucideIcons.chevron_right),
                          onTap: () {
                            final userData =
                                context.read<UserDataModel>().value;
                            pushScreenWithoutNavBar(
                              context,
                              UserInfoScreen(userData: userData!),
                            );
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Đổi mật khẩu"),
                          trailing: const Icon(LucideIcons.chevron_right),
                          onTap: () {
                            final userData =
                                context.read<UserDataModel>().value;
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
                        SwitchListTile(
                          value: savePassword,
                          onChanged: (value) {
                            if (isBiometricAvailable == false) {
                              _notifyNoBiometric();
                            } else {
                              setState(() {
                                savePassword = value;
                              });
                              _handleSavePassword();
                              if (value) {
                                _handleBiometricAuth();
                              }
                            }
                          },
                          title: const Text(
                            "Đăng nhập bằng sinh trắc học",
                            style: TextStyle(),
                          ),
                          visualDensity: VisualDensity.compact,
                          contentPadding: EdgeInsets.zero,
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
                          title: const Text("Đăng xuất"),
                          titleTextStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF5254),
                          ),
                          trailing: const Icon(
                            LucideIcons.chevron_right,
                            color: Color(0xFFFF5254),
                          ),
                          onTap: _handleLogout,
                          visualDensity: VisualDensity.compact,
                        ),
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
