import "package:driver_app/core/api_client.dart";
import "package:driver_app/core/secure_store.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "home.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _username = "";
  var _password = "";

  final _formKey = GlobalKey<FormState>();
  final apiClient = ApiClient();

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  var _passwordVisible = false;

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
          await SecureStorage()
              .writeSecureData("access_token", res["access_token"]);
          await SecureStorage()
              .writeSecureData("last_logged_in_username", _username);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6360FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F1FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 450,
              child: Form(
                key: _formKey,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 48.0,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        TextFormField(
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        const SizedBox(height: 30),
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
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(48, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF6360FF),
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {},
                                child: const Icon(LucideIcons.scan_face),
                              ),
                            ),
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
          ],
        ),
      ),
    );
  }
}
