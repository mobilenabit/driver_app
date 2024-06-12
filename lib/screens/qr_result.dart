import 'package:flutter/material.dart';

class QrResultScreen extends StatelessWidget {
  final String code;
  final Function() closeScreen;

  const QrResultScreen({super.key, required this.closeScreen, required this.code});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
