import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utility {
  checkWeightRegEx(String value) {
    value = value.replaceAll(RegExp(r"\s"), "");
    value = value.replaceAll(RegExp(r"[^.\d]"), "");
    final RegExp reg = RegExp(r"[0-9]+\.[0-9]{1}$");

    var result = reg.hasMatch(value);

    return result ? {"bool": true, "replaceValue": value} : {"bool": false, "replaceValue": value};
  }

  /// 한글 오름차순 정렬하여 리턴
  List sortingName(List beanList) {
    var copyBeanList = [...beanList];
    copyBeanList.sort((a, b) {
      return a["name"]!.compareTo(b["name"]!);
    });
    return copyBeanList;
  }

  /// 중량에 소수점 붙이기
  String parseToDoubleWeight(int value) {
    String returnValue = "";
    if (value < 10) {
      returnValue = "0.$value";
    } else {
      String stringValue = value.toString();
      var left = stringValue.substring(0, stringValue.length - 1);
      var right = stringValue.substring(stringValue.length - 1, stringValue.length);
      returnValue = "$left.$right";
    }
    return returnValue;
  }

  /// 투입량이 총 중량 넘지 않는지 체크하기
  bool checkOverWeight(String totalWeight, String inputWeight) {
    // \d+.{1}\dkg$
    int iTotalWeight = int.parse(totalWeight.replaceAll(".", ""));
    int iInputWeight = int.parse(inputWeight.replaceAll("", ""));

    print("T :: $iTotalWeight \n I :: $iInputWeight");

    return false;
  }

  /// 날짜에 년월일 붙이기
  String pasteTextToDate(String date) => "${date.replaceFirst("-", "년 ").replaceFirst("-", "월 ")}일";

  /// 날짜 형식 (YY-MM-DD)
  String dateFormattingYYMMDD(String date) {
    List divideDate = date.split("-");
    return "${divideDate[0]}-${divideDate[1].padLeft(2, "0")}-${divideDate[2].padLeft(2, "0")}";
  }

  /// 날짜순 정렬
  List sortingDate(List list) {
    List copyList = [...list];
    copyList.forEach((e) {
      List divide = e["date"].toString().split("-");
      String month = divide[1].toString().padLeft(2, "0");
      String day = divide[2].toString().padLeft(2, "0");
    });
    copyList.sort((a, b) => a["date"].compareTo(b["date"]));
    return copyList;
  }

  /// 키보드 입력 시 스크롤 이동
  void moveScrolling(ScrollController scrollCtrl) {
    Future.delayed(const Duration(milliseconds: 470), () {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(
          scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  /// 숫자 단위 표시
  String numberFormat(String value) => NumberFormat.simpleCurrency(
        locale: "ko-KR",
        name: "",
        decimalDigits: 1,
      ).format(double.parse(value));
}
