import 'package:bean_diary/sqflite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehousingGreenBeanController extends GetxController {
  final companyTECtrl = TextEditingController();
  final weightTECtrl = TextEditingController();
  final roastingWeightTECtrl = TextEditingController();
  final blendNameTECtrl = TextEditingController();

  RxString _day = "".obs;
  RxString _company = "".obs;
  RxList _beanList = <String?>[].obs;
  final _selectedBean = Rxn<String>();
  RxString _weight = "".obs;
  RxString _roastingWeight = "".obs;
  // RxInt _listType = 2.obs;
  final _listType = Rxn<int>();

  RxList<Map<String, dynamic>> _greenBeanStockList = <Map<String, dynamic>>[].obs;

  RxBool _isLoading = true.obs;

  get company => _company.value;
  get beanList => _beanList;
  get selectedBean => _selectedBean.value;
  get weight => _weight.value;
  get roastingWeight => _roastingWeight.value;
  get listType => _listType.value;

  get greenBeanStockList => _greenBeanStockList;

  get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // getBeanList();
    print("⭕️ WAREHOUSING GREEN BEAN CONTROLLER INIT");
  }

  setListType(int value) {
    _listType(value);
    getBeanList();
  }

  getBeanList() async {
    print("😍 종합 원두 목록 가져오기 타입 : $listType");
    switch (listType) {
      // 생두
      case 0:
        {
          await GreenBeansSqfLite().openDB();
          List beanList = await GreenBeansSqfLite().getGreenBeans();
          if (beanList.isNotEmpty) {
            beanList = Utility().sortingName(beanList);
            for (var item in beanList) {
              _beanList.add(item["name"]);
            }
          }
          print("🌿 원두리스트 ::: $_beanList");
          _isLoading(false);
          return;
        }
      // 원두
      case 1:
        {
          _isLoading(false);
          return;
        }
      // 생두 재고
      case 2:
        {
          await GreenBeanStockSqfLite().openDB();
          List greenBeanStockList = await GreenBeanStockSqfLite().getGreenBeanStock();
          if (greenBeanStockList.isNotEmpty) {
            for (var item in greenBeanStockList) {
              _beanList.add("${item["name"]} / ${Utility().parseToDoubleWeight(item["weight"])}kg");
              _greenBeanStockList.add({item["name"]: item["weight"]});
            }
          }
          // _beanList(greenBeanStockList);
          print("🥶 생두 재고 리스트 : $_beanList");
          print(" 💯 생두 재고 맵 데이터 : $_greenBeanStockList");
          _isLoading(false);
          return;
        }
      default:
        return;
    }
  }

  void setCompany(String value) {
    _company(value);
  }

  void setSelectBean(String value) {
    _selectedBean(value);
  }

  @override
  void onClose() {
    super.onClose();
    print("❌  WAREHOUSING GREEN BEAN CONTROLLER CLOSE");
  }
}
