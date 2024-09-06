// ignore_for_file: use_build_context_synchronously

import "dart:convert";
import "package:conditional_wrap/conditional_wrap.dart";
import "package:driver_app/components/text_field.dart";
import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:flutter_svg/svg.dart";
import "../../components/password_validator.dart";
import "../../core/api_client.dart";
import "../../core/secure_store.dart";
import "login.dart";

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
  final apiClient = ApiClient();
  String _oldPassword = "";
  String _newPassword = "";
  String _confirmPassword = "";
  bool _isError = false;

  final _formKey = GlobalKey<FormState>();
  var newPasswordController = TextEditingController();

  void _handleConfirm() async {
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
      _handleChangePassword();
    } else {
      _handleForgotPassword();
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

  void _handleChangePassword() async {
    final size = MediaQuery.of(context).size;
    if (widget.userData["phoneNumber"] == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tài khoản chưa cấu hình số điện thoại!"),
        backgroundColor: Colors.red,
      ));

      return;
    }

    if (_formKey.currentState!.validate()) {
      final validatePassword =
          await apiClient.verifyOldPassword(widget.userData, _oldPassword);
      if (validatePassword["error"] == "Error_PASSWORD_IDENTICAL" ||
          validatePassword["error"] == null) {
        if (_formKey.currentState!.validate()) {
          final res = await apiClient.changePasswordWithoutOTP(
              widget.userData, _oldPassword, _newPassword);

          Navigator.pop(context);

          if (res["success"]) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext builder) {
                  return Scaffold(
                    body: Container(color: Colors.white),
                  );
                },
              ),
              (route) => false,
            );

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
                                onPressed: () async {
                                  await const SecureStorage()
                                      .deleteSecureData("logged_in");
                                  await const SecureStorage()
                                      .deleteSecureData("access_token");

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false,
                                  );
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
      } else {
        Navigator.pop(context);
        setState(() {
          _isError = true;
        });
        return;
      }
    }
  }

  void _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
       const SecureStorage().deleteSecureData("last_logged_in_user_name");
       const SecureStorage().deleteSecureData("last_logged_in_user_avatar");
       const SecureStorage()
          .deleteSecureData("last_logged_in_user_phone_number");
       const SecureStorage().deleteSecureData("last_logged_in_username");

      final res = await apiClient.resetPassword(
          widget.userData, _newPassword, widget.userData["otp"]);
      Navigator.pop(context);

      if (res["success"]) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _oldPassword = "";
    _newPassword = "";
    _confirmPassword = "";
    _isError = false;
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
                        builder: (BuildContext context) =>
                            const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: child,
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFF6360FF),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          foregroundColor: const Color(0xFFFCFCFF),
          backgroundColor: const Color(0xFF6360FF),
          surfaceTintColor: const Color(0xFF6360FF),
          title: Text(
            widget.changePassword ? "Đổi mật khẩu" : "Quên mật khẩu",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            iconSize: 24,
            alignment: Alignment.center,
            icon: const Icon(
              LucideIcons.chevron_left,
              weight: 100,
            ),
            onPressed: () {
              if (widget.changePassword) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFEEEFF8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
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
                                      enabledBorderColor: Colors.transparent,
                                      focusedBorderColor:
                                          const Color(0xFF6360FF),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      label: "Mật khẩu cũ",
                                      hintText: "Nhập mật khẩu cũ",
                                      isPasswordField: true,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_isError) {
                                            _isError = false;
                                          }

                                          _oldPassword = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Mật khẩu cũ không được để trống!";
                                        }

                                        if (_isError) {
                                          return "Mật khẩu cũ không chính xác!";
                                        }

                                        return null;
                                      },
                                    ),
                                  CustomTextField(
                                    enabledBorderColor: Colors.transparent,
                                    focusedBorderColor: const Color(0xFF6360FF),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
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
                                                  widget
                                                      .userData["userName"])) {
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
                                    enabledBorderColor: Colors.transparent,
                                    focusedBorderColor: const Color(0xFF6360FF),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
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
                                                ? _handleConfirm
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
                                            child: Text(
                                              widget.changePassword
                                                  ? "Xác nhận"
                                                  : "Tiếp tục",
                                              style: const TextStyle(
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
