import 'dart:io';

import 'package:bean_diary/widgets/enums.dart';
import 'package:bean_diary/widgets/register_result_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDialog {
  customSnackBar(
    BuildContext context,
    String content,
    bool isError,
    bool isLongTime,
  ) {
    final height = MediaQuery.of(context).size.height;
    return SnackBar(
      backgroundColor: isError ? const Color(0xffD24545) : Colors.brown[800],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      duration: Duration(seconds: isLongTime ? 10 : 5),
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
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future showAlertDialog(
    BuildContext context,
    String title,
    String content, {
    String acceptTitle = "확인",
    String cancelTitle = "취소",
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
                  child: Text(cancelTitle),
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

  /// 등록 결과 안내 스낵바 보여주기
  showRegisterResultSnackBar(BuildContext context, SnackBarType type) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(minutes: 1),
      content: RegisterResultSnackBar.stock(
        snackBarType: type,
        date: "24-22-22",
        supplier: "공급할거야",
        selectedBean: "생생 원두",
        inputWeight: "31239",
        message: "입고 등록이 완료되었습니다.",
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 25-03-14
  ///
  /// 생두 입고 등록 완료 스낵바
  showRegisterStockResultSnackBar(BuildContext context, Map<String, dynamic> data) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      duration: const Duration(seconds: 15),
      content: RegisterResultSnackBar.stock(
        snackBarType: SnackBarType.stock,
        date: data["date"],
        supplier: data["supplier"],
        selectedBean: data["selectedBean"],
        inputWeight: data["inputWeight"],
        message: "생두 입고 등록이 완료되었습니다.",
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 25-03-17
  ///
  /// 싱글오리진 로스팅 등록 완료 스낵바
  showRegisterSingleOriginRoastingResultSnackBar(BuildContext context, Map<String, dynamic> data) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      duration: const Duration(seconds: 10),
      content: RegisterResultSnackBar.singleOriginRoasting(
        snackBarType: SnackBarType.singleOriginRoasting,
        date: data["date"],
        selectedBean: data["selectedBean"],
        inputWeight: data["inputWeight"],
        outputWeight: data["outputWeight"],
        message: "싱글오리진 로스팅 등록이 완료되었습니다.",
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 25-03-17
  ///
  /// 블렌드 로스팅 등록 완료 스낵바
  showRegisterBlendRoastingResultSnackBar(BuildContext context, Map<String, dynamic> data) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      duration: const Duration(seconds: 10),
      content: RegisterResultSnackBar.blendRoasting(
        snackBarType: SnackBarType.blendRoasting,
        date: data["date"],
        blendName: data["blendName"],
        inputList: data["inputList"],
        outputWeight: data["outputWeight"],
        message: "블렌드 로스팅 등록이 완료되었습니다.",
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 25-03-18
  ///
  /// 판매 등록 완료 스낵바
  showRegisterSalesResultSnackBar(BuildContext context, Map<String, dynamic> data) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      duration: const Duration(seconds: 10),
      content: RegisterResultSnackBar.sale(
        snackBarType: SnackBarType.sale,
        date: data["date"],
        retailer: data["retailer"],
        selectedBean: data["selectedBean"],
        saleWeight: data["saleWeight"],
        message: "판매 등록이 완료되었습니다.",
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 앱 종료 알림창
  Future<bool> appTerminationAlert(BuildContext context) async {
    bool? confirm = await showAlertDialog(context, "앱 종료", "앱을 종료하시겠습니까?");
    if (confirm == true) {
      SystemNavigator.pop();
      return true;
    } else {
      return false;
    }
  }
}
