import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDialog {
  customSnackBar(BuildContext context, String content, bool isError, bool isLongTime) {
    final height = MediaQuery.of(context).size.height;
    return SnackBar(
      backgroundColor: isError ? const Color(0xffD24545) : Colors.brown,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      duration: Duration(seconds: isLongTime ? 7 : 3),
      content: Text(
        content,
        style: TextStyle(
          fontSize: height / 56,
          color: Colors.white,
        ),
      ),
    );
  }

  showSnackBar(
    BuildContext context,
    String msg, {
    bool isError = false,
    bool isLongTime = false,
  }) {
    SnackBar snackBar = CustomDialog().customSnackBar(
      context,
      msg,
      isError,
      isLongTime,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  /// 앱 종료 알림창
  Future<bool> appTerminationAlert(BuildContext context) async {
    bool confirm = await showAlertDialog(context, "앱 종료", "앱을 종료하시겠습니까?");
    if (confirm) {
      SystemNavigator.pop();
      return true;
    } else {
      return false;
    }
  }
}
