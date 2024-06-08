import "dart:convert";

import "package:conditional_wrap/conditional_wrap.dart";
import "package:flutter/material.dart";
import "package:driver_app/components/password_validator.dart";
import "package:driver_app/components/text_field.dart";
import "package:driver_app/core/api_client.dart";
import "package:driver_app/screens/login.dart";
import "package:driver_app/screens/otp.dart";

import "../core/secure_store.dart";

class ChangePasswordScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool changePassword;

  const ChangePasswordScreen({
    super.key,
    required this.userData,
    required this.changePassword,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _oldPassword = "";
  String _newPassword = "";
  String _confirmPassword = "";

  final _formKey = GlobalKey<FormState>();
  var newPasswordController = TextEditingController();

  void _handlePasswordChange() async {
    if (widget.changePassword) {
      if (widget.userData["data"]["phoneNumber"] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Tài khoản chưa cấu hình số điện thoại!"),
          backgroundColor: Colors.red,
        ));

        return;
      }

      if (_formKey.currentState!.validate()) {
        final otp = await ApiClient().getOtp();
        if (otp["success"]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                userData: widget.userData,
                oldPassword: _oldPassword,
                newPassword: _newPassword,
                changePassword: true,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Có lỗi trong lúc gửi yêu cầu tạo OTP."),
            backgroundColor: Colors.red,
          ));
        }
      }
    } else {
      _handleForgotPassword();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  bool _validateCharacterCount() {
    var regExp = RegExp(r"^.{6,}$");
    return regExp.hasMatch(_newPassword);
  }

  bool _validateCharacterSet() {
    var regExp = RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$");
    return regExp.hasMatch(_newPassword);
  }

  bool _validateConsecutiveCharacters() {
    if (_newPassword.length < 3 || _newPassword.isEmpty) {
      return true;
    }

    for (var i = 0; i < _newPassword.length - 2;) {
      var first = utf8.encode(_newPassword[i].toLowerCase())[0];
      var second = utf8.encode(_newPassword[i + 1].toLowerCase())[0];
      var third = utf8.encode(_newPassword[i + 2].toLowerCase())[0];

      return second == first + 1 && third == second + 1;
    }

    return true;
  }

  bool _checkFields() {
    if (widget.changePassword) {
      return _oldPassword.isNotEmpty &&
          _newPassword.isNotEmpty &&
          _confirmPassword.isNotEmpty &&
          _validateCharacterCount() &&
          _validateCharacterSet() &&
          !_validateConsecutiveCharacters();
    }
    return _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _validateCharacterCount() &&
        _validateCharacterSet() &&
        !_validateConsecutiveCharacters();
  }

  void _handleForgotPassword() async {
    SecureStorage().deleteSecureData("last_logged_in_user_name");
    SecureStorage().deleteSecureData("last_logged_in_user_avatar");
    SecureStorage().deleteSecureData("last_logged_in_user_phone_number");
    SecureStorage().deleteSecureData("last_logged_in_username");

    // TODO: api route
    return;
  }

  @override
  void initState() {
    super.initState();

    _oldPassword = "";
    _newPassword = "";
    _confirmPassword = "";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WidgetWrapper(
      wrapper: (child) => widget.changePassword
          ? child
          : PopScope(
              canPop: false,
              onPopInvoked: (popped) async {
                if (popped) {
                  return;
                }

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: child,
            ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Đổi mật khẩu",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            iconSize: 24,
            color: Colors.black,
            alignment: Alignment.center,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              weight: 100,
            ),
            onPressed: () {
              if (widget.changePassword) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()),
                  (route) => false,
                );
              }
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
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.changePassword)
                                    CustomTextField(
                                        label: "Mật khẩu cũ",
                                        hintText: "Nhập mật khẩu cũ",
                                        isPasswordField: true,
                                        onChanged: (value) {
                                          setState(() {
                                            _oldPassword = value;
                                          });
                                        }),
                                  CustomTextField(
                                    label: "Mật khẩu mới",
                                    hintText: "Nhập mật khẩu mới",
                                    isPasswordField: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _newPassword = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Mật khẩu mới không được để trống!";
                                      }

                                      if (widget.changePassword &&
                                          (value == _oldPassword ||
                                              value ==
                                                  widget.userData["data"]
                                                      ["userName"])) {
                                        return "Mật khẩu mới không được trùng với mật khẩu cũ hoặc tên đăng nhập.";
                                      }

                                      return null;
                                    },
                                  ),
                                  PasswordValidator(
                                    requirement: "Tối thiểu 6 ký tự",
                                    validator: _validateCharacterCount(),
                                  ),
                                  PasswordValidator(
                                    requirement:
                                        "Bao gồm ít nhất 1 chữ số và 1 chữ hoa",
                                    validator: _validateCharacterSet(),
                                  ),
                                  PasswordValidator(
                                    requirement:
                                        "Không chứa 3 ký tự liên tiếp (abc, 123, aBc,...)",
                                    validator:
                                        !_validateConsecutiveCharacters(),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  CustomTextField(
                                    label: "Xác nhận mật khẩu mới",
                                    hintText: "Nhập lại mật khẩu mới",
                                    isPasswordField: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _confirmPassword = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value != _newPassword) {
                                        return "Mật khẩu chưa trùng khớp. Vui lòng thử lại.";
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.9,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _checkFields()
                                                ? _handlePasswordChange
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFFFC709),
                                              disabledForegroundColor:
                                                  Colors.grey,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              shadowColor: Colors.transparent,
                                            ),
                                            child: const Text(
                                              "Xác nhận",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
