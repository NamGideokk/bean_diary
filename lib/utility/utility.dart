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
    print("무게~~~ $value");
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
}
