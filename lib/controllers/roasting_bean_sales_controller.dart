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
    getRoastingBeanStockList();
  }

  getRoastingBeanStockList() async {
    List list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    if (list.isNotEmpty) {
      list = Utility().sortingName(list);
      for (var item in list) {
        _beanList.add("${item["name"]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(item["roasting_weight"]))}kg");
        _beanMapDataList.add(item);
      }
    }
  }

  void setSelectBean(String value) {
    _selectedBean(value);
  }

  void updateBeanListWeight(String name, String useWeight) {
    final divideName = name.split(" / ");
    int weight = int.parse(divideName[1].replaceAll(RegExp("[.,kg]"), ""));
    int iUseWeight = int.parse(useWeight);
    int calcWeight = weight - iUseWeight;
    List copyList = <String?>[..._beanList];
    int findElementIndex = copyList.indexOf(name);
    String replaceString = "${divideName[0]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(calcWeight))}kg";
    copyList[findElementIndex] = replaceString;
    _beanList(copyList);
    _selectedBean(replaceString);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
