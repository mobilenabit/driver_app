import "dart:async";

import "package:driver_app/screens/license_plate.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:local_auth/local_auth.dart";
import "package:store_redirect/store_redirect.dart";

import "../../core/api_client.dart";
import "../../core/secure_store.dart";
import "home.dart";
import "register.dart";

class LoginScreen extends StatefulWidget {
  final bool? isLoggedOut;
  const LoginScreen({super.key, this.isLoggedOut});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Timer? timer;
  bool hasUpdate = false;
  var _username = "";
  var _password = "";
  var _lastUserName = "";
  var _lastUserAvatar = "";
  var _lastUserPhoneNumber = "";

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _apiClient = ApiClient();

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  var _passwordVisible = false;
  var _saveAccount = false;

  bool isBiometricAvailable = false;
  bool newAvailableUpdate = false;
  bool isLoggedOut = false;
  bool biometricSetting = false;
  bool popOnce = true;

  final LocalAuthentication localAuth = LocalAuthentication();

  void _checkBiometric() async {
    isBiometricAvailable = await localAuth.canCheckBiometrics;

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      isBiometricAvailable = true;
    } else {
      isBiometricAvailable = false;
    }
  }

  void _checkBiometricSettings() async {
    var result = await SecureStorage().readSecureData("save_password");
    if (result != null) {
      setState(() {
        biometricSetting = result == "true";
      });
    }
  }

  void _showUpdatePopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cập nhật ứng dụng"),
          content: const Text(
              "Đã có phiên bản mới của ứng dụng. Vui lòng cập nhật để sử dụng."),
          actions: [
            TextButton(
              onPressed: () {
                StoreRedirect.redirect();
                Navigator.pop(context);
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
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

  void _readLastLoggedInData() async {
    final name =
        await SecureStorage().readSecureData("last_logged_in_user_name");
    final avatar =
        await SecureStorage().readSecureData("last_logged_in_user_avatar");
    final number = await SecureStorage()
        .readSecureData("last_logged_in_user_phone_number");
    final username =
        await SecureStorage().readSecureData("last_logged_in_username");

    if (name != null && number != null && username != null && mounted) {
      setState(() {
        _lastUserName = name;
        _lastUserAvatar = avatar ?? "";
        _lastUserPhoneNumber = number;
        _username = username;
      });
    }
  }

  bool _checkLastLoggedInData() {
    return _lastUserName.isNotEmpty && _lastUserPhoneNumber.isNotEmpty;
  }

  Future<void> _handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
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

      dynamic res = await _apiClient.login(_username, _password);
      if (context.mounted) {
        if (res["error"] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res["error_description"]),
              backgroundColor: Colors.red,
            ),
          );

          Navigator.pop(context);
        } else {
          await SecureStorage()
              .writeSecureData("access_token", res["access_token"]);
          if (_saveAccount) {
            await SecureStorage().writeSecureData("logged_in", "true");
          }
          await SecureStorage()
              .writeSecureData("last_logged_in_username", _username);

          Navigator.pop(context);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const LicensePlateScreen();
            }),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.isLoggedOut != null) {
      isLoggedOut = widget.isLoggedOut!;
    }

    super.initState();
    _checkBiometric();
    _checkBiometricSettings();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (newAvailableUpdate && popOnce) {
        _showUpdatePopUp();
        setState(() {
          popOnce = false;
        });
      }
    });
    _readLastLoggedInData();
    _passwordVisible = false;
    _saveAccount = false;
  }

  void _handleBiometricAuth() async {
    bool auth = false;
    try {
      auth = await localAuth.authenticate(
          localizedReason:
              "Vui lòng xác thực bằng vân tay hoặc FaceID để tiếp tục.",
          options: const AuthenticationOptions(biometricOnly: true));
    } on PlatformException {
      const SnackBar(
        content: Text("Xác thực không thành công."),
        backgroundColor: Colors.red,
      );
    } finally {
      if (auth) {
        await SecureStorage().writeSecureData("logged_in", "true");
        var result = await SecureStorage().readSecureData("held_access_token");
        await SecureStorage().writeSecureData("access_token", result);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const HomeScreen(
                selectedLicensePlate: '',
              );
            }),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4e86af),
                Color(0xFFbcd1e1),
                Colors.white,
              ],
              stops: [
                10.01 / 100,
                20.27 / 100,
                100.79 / 100,
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Đăng nhập",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Image.asset(
                          "assets/images/logo.png",
                          scale: 3.0,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Tên đăng nhập không được để trống.";
                                  }

                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: "Tên đăng nhập",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF22689B),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _username = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Mật khẩu không được để trống.";
                                  }

                                  return null;
                                },
                                obscureText: !_passwordVisible,
                                onTapOutside: (event) {
                                  _focusNode.unfocus();
                                },
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: "Mật khẩu",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF22689B),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: _passwordVisible
                                        ? SvgPicture.asset(
                                            "assets/icons/password_visible.svg",
                                            colorFilter: ColorFilter.mode(
                                              _focusNode.hasFocus
                                                  ? const Color(0xFF1B1D29)
                                                  : const Color(0xFFA7ABC3),
                                              BlendMode.srcATop,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            "assets/icons/password_not_visible.svg",
                                            colorFilter: ColorFilter.mode(
                                              _focusNode.hasFocus
                                                  ? const Color(0xFF1B1D29)
                                                  : const Color(0xFFA7ABC3),
                                              BlendMode.srcATop,
                                            ),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    color: const Color(0xFFA7ABC3),
                                    iconSize: 20,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _saveAccount = value!;
                                          });
                                        },
                                        value: _saveAccount,
                                      ),
                                      const Text("Lưu tài khoản"),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Text("Quên mật khẩu?"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.topRight,
                                          colors: [
                                            Color(0xFF206C9D),
                                            Color(0xFF14BBF0),
                                          ],
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: () {
                                          if (newAvailableUpdate) {
                                            _showUpdatePopUp();
                                          } else {
                                            _handleLogin();
                                          }
                                        },
                                        child: const Text(
                                          "Đăng nhập",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      if (isLoggedOut) {
                                        if (biometricSetting == false) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Xác thực"),
                                                content: const Text(
                                                    "Tài khoản chưa bật chế độ xác thực bằng sinh trắc học"),
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
                                        } else if (isBiometricAvailable &&
                                            biometricSetting) {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return AlertDialog(
                                          //       title: const Text("Xác thực"),
                                          //       content: const Text(
                                          //           "Vui lòng sử dụng vân tay hoặc FaceID để xác thực."),
                                          //       actions: [
                                          //         TextButton(
                                          //           onPressed: () {
                                          //             Navigator.pop(context);
                                          //           },
                                          //           child: const Text("Đóng"),
                                          //         ),
                                          //       ],
                                          //     );
                                          //   },
                                          // );
                                          _handleBiometricAuth();
                                        } else {
                                          _notifyNoBiometric();
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Xác thực"),
                                              content: const Text(
                                                  "Vui lòng đăng nhập trước khi sử dụng xác thực bằng sinh trắc học."),
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
                                    },
                                    child: Image.asset(
                                        'assets/icons/ic_faceid.png'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/icons/ic_apple.png",
                              scale: 512 / 64,
                            ),
                            Image.asset("assets/icons/ic_facebook_2x.png"),
                            Image.asset("assets/icons/ic_google_2x.png"),
                            Image.asset("assets/icons/ic_zalo_2x.png"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Bạn chưa có tài khoản?"),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF346890),
                              ),
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RegisterScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       newAvailableUpdate = !newAvailableUpdate;
                        //     });
                        //   },
                        //   child: Text("Debug"),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
