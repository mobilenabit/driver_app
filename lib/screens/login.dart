import "package:driver_app/screens/license_plate.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:driver_app/screens/forgot_password.dart";
import "package:driver_app/screens/home.dart";

import "../core/api_client.dart";
import "../core/helpers.dart";
import "../core/secure_store.dart";
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

  final _formKey = GlobalKey<FormState>();
  final _apiClient = ApiClient();

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  var _passwordVisible = false;
  var flavor = "";

  void _readLastLoggedInData() async {
    final name =
        await SecureStorage().readSecureData("last_logged_in_user_name");
    final avatar =
        await SecureStorage().readSecureData("last_logged_in_user_avatar");
    final number = await SecureStorage()
        .readSecureData("last_logged_in_user_phone_number");
    final username =
        await SecureStorage().readSecureData("last_logged_in_username");

    if (name != null && number != null && username != null) {
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

  bool _checkEnable() {
    return _username.isNotEmpty && _password.isNotEmpty;
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res["error_description"]),
            backgroundColor: Colors.red,
          ));

          Navigator.pop(context);
        } else {
          await SecureStorage()
              .writeSecureData("access_token", res["access_token"]);
          await SecureStorage().writeSecureData("logged_in", "true");
          await SecureStorage()
              .writeSecureData("last_logged_in_username", _username);

          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LicensePlateScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _readLastLoggedInData();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const MethodChannel("flavor")
        .invokeMethod<String>("getFlavor")
        .then((String? output) {
      flavor = output!;
    });
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFF7DD),
                Color(0xFFFFFBF0),
              ],
            ),
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/background.png"),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/images/pvcb_logo.svg"),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.fromLTRB(
                          24, _checkLastLoggedInData() ? 0 : 24, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (_checkLastLoggedInData()) ...[
                            Transform.translate(
                              offset: const Offset(0, -30),
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
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        _lastUserName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.0025),
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
                                              const Color(0xFF3A9EFC),
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
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            TextFormField(
                              focusNode: usernameFocus,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Số điện thoại không được để trống.";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA7ABC3),
                                ),
                                hintText: "Số điện thoại hoặc tên đăng nhập",
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE4E5F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFC709),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                prefixIcon: Transform.scale(
                                  scale: 0.5,
                                  child: SvgPicture.asset(
                                    "assets/icons/user.svg",
                                    colorFilter: ColorFilter.mode(
                                      usernameFocus.hasFocus
                                          ? const Color(0xFF1B1D29)
                                          : const Color(0xFFA7ABC3),
                                      BlendMode.srcATop,
                                    ),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                _username = value;
                              },
                            ),
                            SizedBox(height: 12),
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              hintStyle: const TextStyle(
                                color: Color(0xFFA7ABC3),
                              ),
                              hintText: "Mật khẩu",
                              isDense: true,
                              prefixIcon: Transform.scale(
                                scale: 0.5,
                                child: SvgPicture.asset(
                                  "assets/icons/password_lock.svg",
                                  colorFilter: ColorFilter.mode(
                                    passwordFocus.hasFocus
                                        ? const Color(0xFF1B1D29)
                                        : const Color(0xFFA7ABC3),
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: _passwordVisible
                                    ? SvgPicture.asset(
                                        "assets/icons/password_visible.svg",
                                        colorFilter: ColorFilter.mode(
                                          passwordFocus.hasFocus
                                              ? const Color(0xFF1B1D29)
                                              : const Color(0xFFA7ABC3),
                                          BlendMode.srcATop,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/password_not_visible.svg",
                                        colorFilter: ColorFilter.mode(
                                          passwordFocus.hasFocus
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
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E5F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFC709),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              suffixIconColor: passwordFocus.hasFocus
                                  ? const Color(0xFF1B1D29)
                                  : const Color(0xFFA7ABC3),
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFC709),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 13,
                                    ),
                                  ),
                                  child: const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const ForgotPasswordScreen()))
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF3A9EFC),
                                  ),
                                  child: const Text(
                                    "Quên mật khẩu?",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
