import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_otp_text_field/flutter_otp_text_field.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:driver_app/core/helpers.dart";
import 'package:driver_app/screens/change_password.dart';
import "package:timer_count_down/timer_controller.dart";
import "package:timer_count_down/timer_count_down.dart";

import "../core/api_client.dart";

class OtpScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String oldPassword;
  final String newPassword;
  final bool changePassword;

  const OtpScreen({
    super.key,
    required this.userData,
    required this.oldPassword,
    required this.newPassword,
    required this.changePassword,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _countdownController = CountdownController(autoStart: true);

  void _resendOtpRequest() async {
    _countdownController.restart();

    Map<String, dynamic> otp;

    if (widget.changePassword) {
      otp = await ApiClient().getOtp();
    } else {
      otp = await ApiClient()
          .getOtpAnonymous(widget.userData["data"]["username"]);
    }
    if (!otp["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Có lỗi trong lúc gửi yêu cầu tạo OTP."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _handleResetPassword(Map<String, dynamic> userData, String newPassword,
      String verificationCode) async {
    final res = await ApiClient().verifyOtp(userData["data"], verificationCode);
    print(res.toString());

    if (context.mounted) {
      Navigator.pop(context);
      if (res["success"]) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChangePasswordScreen(
              userData: userData,
              changePassword: false,
            ),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mã OTP không chính xác!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleChangePassword(Map<String, dynamic> userData, String oldPassword,
      String newPassword, String verificationCode) async {
    var size = MediaQuery.of(context).size;
    final res = await ApiClient().changePassword(
        userData["data"], oldPassword, newPassword, verificationCode);

    if (context.mounted) {
      Navigator.pop(context);
      if (!res["success"]) {
        Navigator.pop(context);
        SystemChannels.textInput.invokeMethod("TextInput.hide");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thay đổi mật khẩu thất bại!"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                width: size.width * 0.9,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        SvgPicture.asset(
                          "assets/images/password_success.svg",
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "Cập nhật mật khẩu thành công",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Vui lòng đăng nhập lại với mật khẩu mới.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC709),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "Đăng nhập ngay",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              handleLogout(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber;
    if (widget.changePassword) {
      phoneNumber = widget.userData["data"]["phoneNumber"].trim();
    } else {
      phoneNumber = widget.userData["data"]["username"].trim();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24,
          color: Colors.black,
          alignment: Alignment.center,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            weight: 100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                "Nhập mã OTP để xác thực",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Mã OTP đã được gửi tới số điện thoại",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF82869E),
                ),
              ),
              Text(
                kDebugMode
                    ? phoneNumber
                    : phoneNumber.replaceRange(3, phoneNumber.length - 3,
                        "*" * (phoneNumber.length - 6)),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF82869E),
                ),
              ),
              OtpTextField(
                numberOfFields: 6,
                showFieldAsBox: false,
                borderWidth: 4.0,
                focusedBorderColor: const Color(0xFFFFC709),
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Dialog(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          child: Center(
                            widthFactor: 0.5,
                            heightFactor: 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                      });
                  if (widget.changePassword) {
                    _handleChangePassword(widget.userData, widget.oldPassword,
                        widget.newPassword, verificationCode);
                  } else {
                    _handleResetPassword(
                        widget.userData, widget.newPassword, verificationCode);
                  }
                },
                styles: List.filled(
                  6,
                  const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                cursorColor: const Color(0xFFFFC709),
              ),
              const SizedBox(height: 16),
              Countdown(
                controller: _countdownController,
                seconds: 30,
                build: (BuildContext context, double time) {
                  var seconds = NumberFormat("###").format(time);

                  if (seconds == "0") {
                    return TextButton(
                      onPressed: _resendOtpRequest,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3A9EFC),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh_outlined,
                            weight: 100,
                            size: 20,
                          ),
                          Text(
                            "Gửi lại mã",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3A9EFC),
                      ),
                      child: Text(
                        "Gửi lại mã (${seconds}s)",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
