import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  showCustomSnackBar(
    BuildContext context,
    String content,
    Color bgColor,
    bool isLongTime,
  ) {
    final height = MediaQuery.of(context).size.height;
    return SnackBar(
      backgroundColor: bgColor.withOpacity(0.95),
      duration: Duration(seconds: isLongTime ? 7 : 3),
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

  showFloatingSnackBar(
    BuildContext context,
    String msg, {
    Color bgColor = Colors.deepOrange,
    bool isLongTime = false,
  }) {
    SnackBar errorSnackBar = CustomDialog().showCustomSnackBar(
      context,
      msg,
      bgColor,
      isLongTime,
    );
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  Future showAlertDialog(
    BuildContext context,
    String title,
    String content, {
    String acceptTitle = "확인",
  }) {
    return Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(acceptTitle),
                ),
              ],
            ),
          )
        : showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                CupertinoDialogAction(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    acceptTitle,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          );
  }
}
