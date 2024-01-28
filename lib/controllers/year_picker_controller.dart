import 'package:get/get.dart';

class YearPickerController extends GetxController {
  final RxString _selectedYear = "".obs;

  get selectedYear => _selectedYear.value;

  @override
  void onInit() {
    super.onInit();
    setInitYear();
  }

  void setInitYear() => _selectedYear(DateTime.now().year.toString());

  void setSelectedYear(int year) => _selectedYear(year.toString());
}
