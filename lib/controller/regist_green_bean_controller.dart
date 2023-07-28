import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:get/get.dart';

class RegistGreenBeanController extends GetxController {
  RxList _greenBeanList = [].obs;

  get greenBeanList => _greenBeanList;

  @override
  void onInit() {
    super.onInit();
    getGreenBeanList();
  }

  void getGreenBeanList() async {
    final list = await GreenBeansSqfLite().getGreenBeans();
    if (list.isNotEmpty) {
      List sortingList = Utility().sortingName(list);
      _greenBeanList(sortingList);
    }
  }

  void deleteGreenBeanElement(int index) {
    List copyList = [..._greenBeanList];
    copyList.removeAt(index);
    _greenBeanList(copyList);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
