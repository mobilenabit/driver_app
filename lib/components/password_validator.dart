import "package:flutter/material.dart";

class PasswordValidator extends StatelessWidget {
  final String requirement;
  final bool validator;

  const PasswordValidator({
    super.key,
    required this.requirement,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(children: [
      Row(
        children: [
          Icon(
            Icons.check_circle,
            fill: 1,
            size: 16,
            color:
                validator ? const Color(0xFF1EBB4D) : const Color(0xFFDCDEE9),
          ),
          SizedBox(width: size.width * 0.01),
          Text(
            requirement,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color:
                  validator ? const Color(0xFF313442) : const Color(0xFF82869E),
            ),
          ),
        ],
      ),
      SizedBox(height: size.height * 0.01),
    ]);
  }
}
