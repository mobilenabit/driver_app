import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:driver_app/screens/change_password.dart";

import "../core/helpers.dart";

class SettingsScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const SettingsScreen({super.key, required this.userData});

  Widget _getAvatarWidget() {
    if (userData?["data"]["avatar"] != null &&
        userData?["data"]["avatar"].isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              userData?["data"]["avatar"],
            ),
          ),
        ),
      );
    } else {
      return const Icon(Icons.account_circle, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4e86af),
            Color(0xFFbcd1e1),
            Colors.white,
            Colors.white,
          ],
          stops: [
            0.01 / 100,
            72.27 / 100,
            100.79 / 100,
            100.79 / 100,
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          constraints: const BoxConstraints.expand(),
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    "Cài đặt",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _getAvatarWidget(),
                            SizedBox(width: size.width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Xin chào,"),
                                userData == null
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        userData?["data"]["displayName"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 5,
                  ),
                  child: const Text(
                    "Cài đặt tài khoản",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // FIXME: icons are not aligned vertically center
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: const Text(
                          "Đổi mật khẩu",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: SvgPicture.asset(
                            "assets/icons/changed_password.svg"),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          weight: 100,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext builder) =>
                                  ChangePasswordScreen(
                                userData: userData!,
                                changePassword: true,
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: SvgPicture.asset("assets/icons/logout.svg"),
                        onTap: () {
                          handleLogout(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
