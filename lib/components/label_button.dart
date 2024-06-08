import "package:flutter/material.dart";

class LabelButton extends StatelessWidget {
  final Widget icon;
  final void Function()? onPressed;
  final String label;
  final TextStyle textStyle;

  const LabelButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.textStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          label,
          style: textStyle,
        ),
      ],
    );
  }
}
