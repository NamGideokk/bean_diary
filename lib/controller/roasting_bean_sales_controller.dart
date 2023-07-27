import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RoastingBeanSalesController extends GetxController {
  final companyTECtrl = TextEditingController();
  final weightTECtrl = TextEditingController();

  final companyFN = FocusNode();
  final weightFN = FocusNode();

  final RxList _beanList = <String?>[].obs;
  RxList _beanMapDataList = [].obs;
  final _selectedBean = Rxn<String>();

  get beanList => _beanList;
  get beanMapDataList => _beanMapDataList;
  get selectedBean => _selectedBean.value;

  @override
  void onInit() {
    super.onInit();
    print("⭕️ ROASTING BEAN SALES CONTROLLER INIT");
    getRoastingBeanStockList();
  }

  getRoastingBeanStockList() async {
    await RoastingBeanStockSqfLite().openDB();
    List list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    if (list.isNotEmpty) {
      list = Utility().sortingName(list);
      for (var item in list) {
        _beanList.add("${item["name"]} / ${Utility().parseToDoubleWeight(item["roasting_weight"])}kg");
        _beanMapDataList.add(item);
      }
    }
    print("원 두 재 고 가 져 옴 : $_beanList");
    print("원 두 재 고 맵 데 이 터 넣 음 : $_beanMapDataList");
  }

  void setSelectBean(String value) {
    _selectedBean(value);
  }

  void updateBeanListWeight(String name, String useWeight) {
    final divideName = name.split(" / ");
    int weight = int.parse(divideName[1].replaceAll(RegExp("[.kg]"), ""));
    int iUseWeight = int.parse(useWeight);
    int clacWeight = weight - iUseWeight;
    List copyList = <String?>[..._beanList];
    int findElementIndex = copyList.indexOf(name);
    String replaceString = "${divideName[0]} / ${Utility().parseToDoubleWeight(clacWeight)}kg";
    copyList[findElementIndex] = replaceString;
    _beanList(copyList);
    _selectedBean(replaceString);
  }

  @override
  void onClose() {
    super.onClose();
    print("❌ ROASTING BEAN SALES CONTROLLER CLOSE");
  }
}
