import 'package:flutter/material.dart';

class CustomDialog {
  showCustomSnackBar(
    BuildContext context,
    String content, {
    Color bgColor = Colors.red,
  }) {
    final height = MediaQuery.of(context).size.height;
    return SnackBar(
      backgroundColor: bgColor.withOpacity(0.95),
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        style: TextStyle(
          fontSize: height / 56,
          color: Colors.white,
        ),
      ),
    );
  }
}
