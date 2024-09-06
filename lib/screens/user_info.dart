import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:intl/intl.dart";

class UserInfoScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const UserInfoScreen({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6360FF),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LucideIcons.chevron_left),
        ),
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        foregroundColor: const Color(0xFFFCFCFF),
        backgroundColor: const Color(0xFF6360FF),
        surfaceTintColor: const Color(0xFF6360FF),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEFF8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Họ và tên"),
                  subtitle: Text(userData?["displayName"]),
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Giới tính"),
                  subtitle: Text(
                    switch (userData?["gender"]) {
                      1 => "Nam",
                      0 => "Nữ",
                      _ => "Chưa có thông tin"
                    },
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Ngày sinh"),
                  subtitle: (userData?["dateOfBirth"] != null)
                      ? Text(DateFormat("dd/MM/yyyy")
                          .format(DateTime.parse(userData?["dateOfBirth"])))
                      : const Text("Chưa có thông tin"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Email"),
                  subtitle: Text(
                    userData?["mail"] ?? "Chưa có thông tin",
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Số điện thoại di động"),
                  subtitle: Text(
                    userData?["phoneNumber"] ?? "Chưa có thông tin",
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}