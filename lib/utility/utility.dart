import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  checkWeightRegEx(String value) {
    value = value.replaceAll(RegExp(r"\s"), "");
    value = value.replaceAll(RegExp(r"[^.\d]"), "");
    final RegExp reg = RegExp(r"[0-9]+\.[0-9]{1}$");

    var result = reg.hasMatch(value);

    return result ? {"bool": true, "replaceValue": value} : {"bool": false, "replaceValue": value};
  }

  /// 한글 오름차순 정렬하여 리턴 (생두, 원두명)
  List sortingName(List beanList) {
    var copyBeanList = [...beanList];
    copyBeanList.sort((a, b) {
      return a["name"]!.compareTo(b["name"]!);
    });
    return copyBeanList;
  }

  /// 한글 오름차순 정렬하여 리턴
  List sortHangulAscending(List beanList) {
    var copyBeanList = [...beanList];
    copyBeanList.sort((a, b) {
      return a.compareTo(b);
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

  /// 날짜에 년월일 붙이기
  String pasteTextToDate(String date) => "${date.replaceFirst("-", "년 ").replaceFirst("-", "월 ")}일";

  /// 날짜 형식 (YY-MM-DD)
  String dateFormattingYYMMDD(String date) {
    List divideDate = date.split("-");
    return "${divideDate[0]}-${divideDate[1].padLeft(2, "0")}-${divideDate[2].padLeft(2, "0")}";
  }

  /// 날짜순 정렬
  List sortingDate(List list) {
    List copyList = list.map((e) => Map.from(e)).toList();

    for (var e in copyList) {
      List divide = e["date"].toString().split("-");
      String year = divide[0].toString();
      String month = divide[1].toString().padLeft(2, "0");
      String day = divide[2].toString().padLeft(2, "0");
      e["date"] = "$year-$month-$day";
    }
    copyList.sort((a, b) {
      return DateTime.parse(b["date"]).compareTo(DateTime.parse(a["date"]));
    });
    return copyList;
  }

  /// 키보드 입력 시 스크롤 이동
  void moveScrolling(ScrollController scrollCtrl) {
    Future.delayed(const Duration(milliseconds: 500), () {
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
  String numberFormat(String value, {bool isWeight = true}) => NumberFormat.simpleCurrency(
        locale: "ko-KR",
        name: "",
        decimalDigits: isWeight ? 1 : 0,
      ).format(double.parse(value));

  /// 생두·원두 / 중량 각각 나누기
  ///
  ///     * int type = 1 : 이름 return
  ///     *     type = 2 : 중량 return
  splitNameAndWeight(String value, int type) {
    if (!value.contains(" / ")) return;
    List splitValue = value.split(" / ");
    return splitValue[type == 1 ? 0 : 1];
  }

  /// 25-03-16
  ///
  /// 입력한 중량 정규표현식 검사
  ///
  /// * 숫자만 입력, 소수점 자리 수 확인 등
  /// * true = 통과
  bool checkRegExpWeight(String weight) {
    final regex = RegExp(r"^(0\.[1-9]|[1-9][0-9]*(\.[0-9])?)$");
    return regex.hasMatch(weight);
  }

  /// 25-03-16
  ///
  /// 입력한 중량 소수점 포함 확인하기
  String hasDecimalPointInWeight(String weight) {
    bool hasPoint = weight.contains(".");
    if (hasPoint) {
      return weight;
    } else {
      return "$weight.0";
    }
  }

  /// 25-03-16
  ///
  /// 로스팅 등록 > 생두 투입량 유효성 검사하기
  ///
  /// * true = 유효성 통과
  bool validateInputWeight(String inventory, String inputWeight) {
    List extractInventory = inventory.split(" / ");
    String inventoryWeight = extractInventory[1].replaceAll(RegExp(r'[,.kg]'), "");

    return int.parse(inventoryWeight) < int.parse(inputWeight.replaceAll(".", "")) ? false : true;
  }

  /// 25-03-16
  ///
  /// 로스팅 등록 > 로스팅 후 배출량 유효성 검사하기
  ///
  /// * true = 유효성 통과
  bool validateOutputWeight(String inputWeight, String outputWeight) {
    int ipWeight = int.parse(inputWeight.replaceAll(".", ""));
    int opWeight = int.parse(outputWeight.replaceAll(".", ""));

    return ipWeight <= opWeight ? false : true;
  }

  /// 25-03-01
  ///
  /// 배열 길이에 맞게 유동적으로 색상 분배하기
  Color getDynamicBrownColor(int index, int length) {
    if (length == 1) return Colors.brown;

    double ratio = index / (length - 1);
    return Color.lerp(Colors.brown[900], Colors.brown[50], ratio)!;
  }

  /// 25-03-18
  ///
  /// 중량 단위 변환기
  convertWeightUnit(String weight) {
    int intWeight = int.parse(weight.replaceAll(".", ""));
    if (intWeight == 0) {
      return "0.0kg";
    } else if (intWeight > 0 && intWeight < 10) {
      return "${intWeight * 100}g";
    } else if (intWeight >= 10 && intWeight <= 9999) {
      return "${Utility().parseToDoubleWeight(intWeight)}kg";
    } else if (intWeight >= 10000 && intWeight <= 9999999) {
      return "${Utility().numberFormat(Utility().parseToDoubleWeight(int.parse((intWeight / 10000).toStringAsFixed(1).replaceAll(".", ""))))}t";
    } else {
      return "${Utility().numberFormat(Utility().parseToDoubleWeight(int.parse((intWeight / 10000000).toStringAsFixed(1).replaceAll(".", ""))))}kt";
    }
  }
}
