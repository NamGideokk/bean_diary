import 'package:get/get.dart';

class CustomDatePickerController extends GetxController {
  final _now = DateTime.now();
  late final RxInt _thisYear = 0.obs;
  final RxInt _year = 0.obs;
  final RxInt _month = 1.obs;
  final RxInt _day = 1.obs;
  final RxString _date = "".obs;

  get thisYear => _thisYear.value;
  get year => _year.value;
  get month => _month.value;
  get day => _day.value;
  get date => _date.value;

  @override
  void onInit() {
    super.onInit();
    _thisYear(_now.year);
    _year(_now.year);
    _month(_now.month);
    _day(_now.day);
    _date("${_year.toString()}-${_month.toString()}-${_day.toString()}");
  }

  void setDateToToday() {
    _year(_now.year);
    _month(_now.month);
    _day(_now.day);
    _date("${_now.year.toString()}-${_now.month.toString()}-${_now.day.toString()}");
  }

  void setYear(int year) => _year(year);

  void setMonth(int month) => _month(month);

  void setDay(int day) => _day(day);

  void setDate() => _date("${_year.toString()}-${_month.toString()}-${_day.toString()}");
}
