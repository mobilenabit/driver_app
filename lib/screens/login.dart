import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:local_auth/local_auth.dart";
import "../../core/api_client.dart";
import "../../core/secure_store.dart";
import "home.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _username = "";
  var _password = "";
  var _lastUserName = "";
  var _lastUserAvatar = "";
  var _lastUserPhoneNumber = "";
  bool isBiometricAvailable = false;
  bool biometricSetting = false;

  final _formKey = GlobalKey<FormState>();

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  var _passwordVisible = false;

  void _readLastLoggedInData() async {
    final name = await secureStorage.readSecureData("last_logged_in_user_name");
    final avatar =
        await secureStorage.readSecureData("last_logged_in_user_avatar");
    final number =
        await secureStorage.readSecureData("last_logged_in_user_phone_number");
    final username =
        await secureStorage.readSecureData("last_logged_in_username");

    if (name != null && number != null && username != null && mounted) {
      setState(() {
        _lastUserName = name;
        _lastUserAvatar = avatar ?? "";
        _lastUserPhoneNumber = number;
        _username = username;
      });
    }
  }

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

    var result = await const SecureStorage().readSecureData("save_password");
    if (result != null) {
      setState(() {
        biometricSetting = result == "true";
      });
    }
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
        await const SecureStorage().writeSecureData("logged_in", "true");
        var result =
            await const SecureStorage().readSecureData("held_access_token");
        await const SecureStorage().writeSecureData("access_token", result);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }),
            (route) => false,
          );
        }
      }
    }
  }

  bool _checkLastLoggedInData() {
    return _lastUserName.isNotEmpty;
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

      dynamic res = await apiClient.login(_username, _password);
      if (kDebugMode) {
        print(res);
      }

      Navigator.pop(context);

      if (context.mounted) {
        if (res["error"] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res["error_description"]),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          await secureStorage.writeSecureData("logged_in", "true");
          await secureStorage.writeSecureData(
              "access_token", res["access_token"]);
          await secureStorage.writeSecureData(
              "last_logged_in_username", _username);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _readLastLoggedInData();
    _checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6360FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Container(
              alignment: Alignment.center,
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1FA),
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/images/PetroNET_Logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
              // child: const Text(
              //   "DigiOil",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontWeight: FontWeight.w600,
              //     fontSize: 48,
              //   ),
              // ),
            ),
            const Spacer(),
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          32, _checkLastLoggedInData() ? 0 : 48, 32, 48),
                      child: Column(
                        children: [
                          if (_checkLastLoggedInData()) ...[
                            Transform.translate(
                              offset: const Offset(0, -40),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (_lastUserAvatar == "")
                                        Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Icon(
                                              Icons.account_circle,
                                              size: 80),
                                        ),
                                      if (_lastUserAvatar != "")
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(_lastUserAvatar),
                                            ),
                                          ),
                                        ),
                                      Text(
                                        _lastUserName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        _lastUserPhoneNumber.trim(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _lastUserName = "";
                                            _lastUserAvatar = "";
                                            _lastUserPhoneNumber = "";
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF6360FF),
                                        ),
                                        child: const Text(
                                          "Đăng nhập tài khoản khác",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (!_checkLastLoggedInData()) ...[
                            TextFormField(
                              focusNode: usernameFocus,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tên đăng nhập không được để trống.";
                                }

                                return null;
                              },
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFFCFCFF),
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA7ABC3),
                                ),
                                hintText: "Tên đăng nhập",
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6360FF),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  LucideIcons.user,
                                  color: Color(0xFF6360FF),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _username = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                          TextFormField(
                            focusNode: passwordFocus,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mật khẩu không được để trống.";
                              }

                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFFCFCFF),
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              hintStyle: const TextStyle(
                                color: Color(0xFFA7ABC3),
                              ),
                              hintText: "Mật khẩu",
                              isDense: true,
                              prefixIcon: const Icon(
                                LucideIcons.lock,
                                color: Color(0xFF6360FF),
                              ),
                              suffixIcon: IconButton(
                                icon: _passwordVisible
                                    ? const Icon(LucideIcons.eye_off)
                                    : const Icon(LucideIcons.eye),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E5F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6360FF),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              suffixIconColor: passwordFocus.hasFocus
                                  ? const Color(0xFF1B1D29)
                                  : const Color(0xFFA7ABC3),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(48, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF6360FF),
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: _handleLogin,
                                  child: const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: biometricSetting ? 16 : 0),
                              biometricSetting
                                  ? Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          fixedSize: const Size(48, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF6360FF),
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: () {
                                          if (_checkLastLoggedInData()) {
                                            if (!biometricSetting) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("Xác thực"),
                                                    content: const Text(
                                                        "Tài khoản chưa bật chế độ xác thực bằng sinh trắc học"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("Đóng"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (isBiometricAvailable &&
                                                biometricSetting) {
                                              _handleBiometricAuth();
                                            } else {
                                              _notifyNoBiometric();
                                            }
                                          }
                                          ;
                                        },
                                        child:
                                            const Icon(LucideIcons.scan_face),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Quên mật khẩu?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFF8181),
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
          ],
        ),
      ),
    );
  }
}
