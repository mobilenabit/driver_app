import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "login.dart";

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _fullName = "";
  var _dateOfBirth = DateTime.now();
  var _phoneNumber = "";
  var _refCode = "";
  var _username = "";
  var _password = "";
  var _passwordConfirmation = "";
  var _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _fullName = "";
    _dateOfBirth = DateTime.now();
    _phoneNumber = "";
    _refCode = "";
    _username = "";
    _password = "";
    _passwordConfirmation = "";
    _passwordVisible = false;

    super.initState();
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
              "Đăng ký",
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
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
                                      return "Họ và tên không được để trống.";
                                    }

                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Họ và tên",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF22689B),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _fullName = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        decoration: const InputDecoration(
                                          hintText: "Ngày sinh",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF22689B),
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _password = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          hintText: "Số điện thoại",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF22689B),
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _phoneNumber = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Mã người giới thiệu",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF22689B),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _refCode = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
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
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          onPressed: () {},
                                          child: const Text(
                                            "Đăng ký",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                              const Text("Bạn đã có tài khoản?"),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF346890),
                                ),
                                child: const Text(
                                  "Đăng nhập",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false);
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
