import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";

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
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final Color disabledBorderColor;
  final bool enabled;

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
    this.enabledBorderColor = const Color(0xFFE4E5F0),
    this.disabledBorderColor = const Color(0xFFE4E5F0),
    this.focusedBorderColor = const Color(0xFFFFC709),
    this.inputFormatters,
    this.initialValue,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 4),
        TextFormField(
          enabled: widget.enabled,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
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
              horizontal: 12,
              vertical: 12,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFFA7ABC3),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFE43434),
            ),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.enabledBorderColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.disabledBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
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
            filled: true,
            fillColor: const Color(0xFFFCFCFF),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: _obscureText
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
                        _obscureText = !_obscureText;
                      });
                    },
                    color: const Color(0xFFA7ABC3),
                    iconSize: 20,
                  )
                : widget.suffixIcon,
            hintText: widget.hintText,
          ),
          onChanged: widget.onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}