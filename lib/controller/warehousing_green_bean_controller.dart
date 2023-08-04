import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehousingGreenBeanController extends GetxController {
  final companyTECtrl = TextEditingController();
  final weightTECtrl = TextEditingController();
  final List weightTECtrlList = <TextEditingController>[];
  final List weightFNList = <FocusNode>[];
  final roastingWeightTECtrl = TextEditingController();
  final blendNameTECtrl = TextEditingController();
  final blendNameFN = FocusNode();

  RxString _day = "".obs;
  RxString _company = "".obs;
  RxList _beanList = <String?>[].obs;
  final _selectedBean = Rxn<String>();
  RxString _weight = "".obs;
  RxString _roastingWeight = "".obs;
  // RxInt _listType = 2.obs;
  final _listType = Rxn<int>();
  RxInt _roastingType = 1.obs;

  RxList<Map<String, dynamic>> _greenBeanStockList = <Map<String, dynamic>>[].obs;
  RxList<Rxn<String>> _blendBeanList = <Rxn<String>>[].obs;

  RxBool _isLoading = true.obs;

  get company => _company.value;
  get beanList => _beanList;
  get selectedBean => _selectedBean.value;
  get weight => _weight.value;
  get roastingWeight => _roastingWeight.value;
  get listType => _listType.value;
  get roastingType => _roastingType.value;

  get greenBeanStockList => _greenBeanStockList;
  get blendBeanList => _blendBeanList;

  get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
  }

  setListType(int value) {
    _listType(value);
    getBeanList();
  }

  void setRoastingType(int value) {
    _roastingType(value);
  }

  getBeanList() async {
    _beanList.clear();
    switch (listType) {
      // 생두
      case 0:
        {
          List beanList = await GreenBeansSqfLite().getGreenBeans();
          if (beanList.isNotEmpty) {
            beanList = Utility().sortingName(beanList);
            for (var item in beanList) {
              _beanList.add(item["name"]);
            }
          }
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
          List greenBeanStockList = await GreenBeanStockSqfLite().getGreenBeanStock();
          if (greenBeanStockList.isNotEmpty) {
            for (var item in greenBeanStockList) {
              _beanList.add("${item["name"]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(item["weight"]))}kg");
              _greenBeanStockList.add({item["name"]: item["weight"]});
            }
          }
          _isLoading(false);
          return;
        }
      default:
        return;
    }
  }

  void deleteBeanList(int index) {
    List copyList = <String?>[..._beanList];
    copyList.removeAt(index);
    _beanList(copyList);
  }

  void updateBeanListWeight(String name, String useWeight) {
    final beforeSelectedBean = _selectedBean;
    final divideName = name.split(" / ");
    int weight = int.parse(divideName[1].replaceAll(RegExp("[.,kg]"), ""));
    int iUseWeight = int.parse(useWeight);
    int calcWeight = weight - iUseWeight;
    List copyList = <String?>[..._beanList];
    int findElementIndex = copyList.indexOf(name);
    String replaceString = "${divideName[0]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(calcWeight))}kg";
    copyList[findElementIndex] = replaceString;
    _beanList(copyList);
    if (roastingType == 1) {
      _selectedBean(replaceString);
    } else {
      if (beforeSelectedBean == name) {
        _selectedBean(replaceString);
      }
    }
  }

  void setCompany(String value) {
    _company(value);
  }

  void setSelectBean(String value) {
    _selectedBean(value);
  }

  void addBlendBeanList(String value) {
    bool dupCheck = false;
    if (_blendBeanList.isNotEmpty) {
      dupCheck = _blendBeanList.any((e) {
        return (e == value);
      });
    }
    if (dupCheck) {
      return;
    }
    addWeightCtrlList();
    final addElement = Rxn<String>();
    addElement(value);
    _blendBeanList.add(addElement);
  }

  void deleteBlendBeanList(int index) {
    _blendBeanList.removeAt(index);
    weightTECtrlList[index].dispose();
    weightTECtrlList.removeAt(index);
    weightFNList[index].dispose();
    weightFNList.removeAt(index);
  }

  void addWeightCtrlList() {
    final weightTECtrl = TextEditingController();
    final weightFN = FocusNode();
    weightTECtrlList.add(weightTECtrl);
    weightFNList.add(weightFN);
  }

  void initBlendInfo() {
    _blendBeanList.clear();
    weightTECtrlList.clear();
    weightFNList.clear();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
