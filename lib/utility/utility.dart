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
}
