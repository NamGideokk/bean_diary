import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomDatePickerController extends GetxController {
  final TextEditingController textEditingCtrl = TextEditingController();
  final _now = DateTime.now();
  RxString _year = "".obs;
  RxString _month = "".obs;
  RxString _day = "".obs;
  RxString _date = "".obs;

  get date => _date.value;

  @override
  void onInit() {
    super.onInit();
    print("⭕️ CUSTOM DATE PICKER CONTROLLER INIT");
    _year(_now.year.toString());
    _month(_now.month.toString());
    _day(_now.day.toString());
    _date("$_year-$_month-$_day");
    textEditingCtrl.text = "$_year년 $_month월 $_day일";
  }

  void setDateToToday() {
    textEditingCtrl.text = "${_now.year}년 ${_now.month}월 ${_now.day}일";
    _date("${_now.year}-${_now.month}-${_now.day}");
  }

  void setYear(String year) {
    _year(year);
  }

  void setMonth(String month) {
    _month(month);
  }

  void setDay(String day) {
    _day(day);
  }

  void setDate(String date) {
    _date("$_year-$_month-$_day");
  }

  @override
  void onClose() {
    super.onClose();
    print("❌️ CUSTOM DATE PICKER CONTROLLER CLOSE");
  }
}