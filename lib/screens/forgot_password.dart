import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:driver_app/components/text_field.dart";
import "package:driver_app/core/api_client.dart";


import "otp.dart";

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _phoneNumber = "";

  final _formKey = GlobalKey<FormState>();

  void _handleForgotPassword() async {
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
    final res = await ApiClient().getOtpAnonymous(_phoneNumber);
    print(res.toString());

    Navigator.pop(context);

    if (res["success"]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OtpScreen(
            userData: {
              "data": {"username": _phoneNumber},
            },
            oldPassword: "",
            newPassword: "",
            changePassword: false,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Có lỗi trong lúc gửi yêu cầu tạo OTP."),
        backgroundColor: Colors.red,
      ));

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Quên mật khẩu",
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
                            child: CustomTextField(
                              label: "Số điện thoại",
                              hintText: "Nhập số điện thoại",
                              textInputType: kDebugMode
                                  ? TextInputType.text
                                  : TextInputType.phone,
                              onChanged: (value) {
                                _phoneNumber = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.9,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _phoneNumber.isNotEmpty
                                ? _handleForgotPassword
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC709),
                              disabledForegroundColor: Colors.grey,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              "Tiếp tục",
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
          ),
        ),
      ),
    );
  }
}
