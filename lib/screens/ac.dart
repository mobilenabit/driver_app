import "package:driver_app/screens/uer_info.dart";
import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:provider/provider.dart";
import "package:local_auth/local_auth.dart";

import "../../core/secure_store.dart";
import "../../core/user_data.dart";
import "change_password.dart";
import "login.dart";

class Settings extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const Settings({
    super.key,
    this.userData,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool savePassword = false;
  bool isBiometricAvailable = false;
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
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
                        decoration: BoxDecoration(
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
            ],
          ),
        ),
      ),
    );
  }
}
