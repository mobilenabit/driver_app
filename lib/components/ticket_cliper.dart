import "package:flutter/material.dart";

class CustomTicketShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(Rect.fromCircle(
        center: Offset(-5, size.height / 2), radius: size.width * 0.062));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width + 5, size.height / 2),
        radius: size.width * 0.062));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}