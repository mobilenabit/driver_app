import "package:flutter/material.dart";

class CustomTextField extends StatefulWidget {
  final bool isPasswordField;
  final void Function(String)? onChanged;
  final String label;
  final String? hintText;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextEditingController? textInputController;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    this.isPasswordField = false,
    required this.label,
    this.onChanged,
    this.hintText,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.textInputController,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        TextFormField(
          textInputAction: widget.textInputAction,
          autovalidateMode: widget.autovalidateMode,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 13,
          ),
          validator: widget.validator,
          keyboardType: widget.textInputType,
          controller: widget.textInputController,
          decoration: InputDecoration(
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFFA7ABC3),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFE43434),
            ),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE4E5F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFFFC709),
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
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    color: const Color(0xFFA7ABC3),
                  )
                : widget.suffixIcon,
            hintText: widget.hintText,
          ),
          onChanged: widget.onChanged,
        ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }
}
