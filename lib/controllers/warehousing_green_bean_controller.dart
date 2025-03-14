import 'dart:convert';

import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehousingGreenBeanController extends GetxController {
  final weightTECtrl = TextEditingController();
  final RxList _weightTECtrlList = <TextEditingController>[].obs;
  final RxList _weightFNList = <FocusNode>[].obs;
  final roastingWeightTECtrl = TextEditingController();

  // 생두 입고 관리
  final greenBeanFN = FocusNode();
  final weightFN = FocusNode();

  final RxString _company = "".obs;
  final RxList _beanList = <String?>[].obs;
  final _selectedBean = Rxn<String>();
  final RxString _weight = "".obs;
  final RxString _roastingWeight = "".obs;
  final _listType = Rxn<int>();
  final RxInt _roastingType = 1.obs;

  final RxList<Map<String, dynamic>> _greenBeanStockList = <Map<String, dynamic>>[].obs;
  final RxList<Rxn<String>> _blendBeanList = <Rxn<String>>[].obs;

  final RxList _suppliers = [].obs; // 공급처 목록
  final RxList _supplierSuggestions = [].obs; // 공급처 추천 목록
  final RxList _blendNames = [].obs; // 블렌드명 전체 목록
  final RxList _blendNameSuggestions = [].obs; // 블렌드명 추천 목록

  final RxList _opacityList = [].obs;

  final RxBool _isLoading = true.obs;

  get company => _company.value;
  get beanList => _beanList;
  get selectedBean => _selectedBean.value;
  get weight => _weight.value;
  get roastingWeight => _roastingWeight.value;
  get listType => _listType.value;
  get roastingType => _roastingType.value;

  get greenBeanStockList => _greenBeanStockList;
  get blendBeanList => _blendBeanList;

  get weightTECtrlList => _weightTECtrlList;
  get weightFNList => _weightFNList;

  get suppliers => _suppliers;
  get supplierSuggestions => _supplierSuggestions;
  get blendNames => _blendNames;
  get blendNameSuggestions => _blendNameSuggestions;

  get opacityList => _opacityList;

  get isLoading => _isLoading.value;

  @override
  void onClose() {
    super.onClose();
    greenBeanFN.dispose();
    weightFN.dispose();
  }

  /// 목록 타입 값 설정하기 (생두/원두)
  Future setListType(int value) async {
    _listType(value);
    await getBeanList();
  }

  /// 로스팅 타입 값 설정하기 (싱글오리진/블렌드)
  void setRoastingType(int value) => _roastingType(value);

  /// 생두/원두 목록 가져오기
  Future getBeanList() async {
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

  /// 생두 목록 삭제하기
  void deleteBeanList(int index) {
    List copyList = <String?>[..._beanList];
    copyList.removeAt(index);
    _beanList(copyList);
  }

  /// 생두 목록 재고량 업데이트하기
  void updateBeanListWeight(String name, String useWeight) {
    final beforeSelectedBean = _selectedBean.value;
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

  /// 업체명 할당하기
  void setCompany(String value) => _company(value);

  /// 선택한 생두 값 할당하기
  void setSelectBean(String value) => _selectedBean(value);

  /// 생두 입고 입력 정보 초기화하기
  void setInitGreenBeanWarehousingInfo() {
    CustomDatePickerController.to.setDateToToday();
    weightTECtrl.clear();
  }

  /// 생두 입고 등록하기
  Future registerWarehousingGreenBean(BuildContext context, String supplier, FocusNode supplierFN) async {
    if (supplier == "") {
      CustomDialog().showSnackBar(context, "공급처(업체명)를 입력해 주세요.");
      supplierFN.requestFocus();
      return;
    }
    if (selectedBean == "" || selectedBean == null) {
      CustomDialog().showSnackBar(context, "생두를 선택해 주세요.");
      greenBeanFN.requestFocus();
      return;
    }
    if (weightTECtrl.text.trim() == "") {
      CustomDialog().showSnackBar(context, "중량을 입력해 주세요.");
      weightFN.requestFocus();
      return;
    }

    if (!weightTECtrl.text.contains(".") && weightTECtrl.text != "") {
      weightTECtrl.text = "${weightTECtrl.text}.0";
    }

    final Map<String, dynamic> result = Utility().checkWeightRegEx(weightTECtrl.text.trim());
    weightTECtrl.text = result["replaceValue"];

    if (!result["bool"]) {
      CustomDialog().showSnackBar(
        context,
        "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
        isError: true,
      );
      weightFN.requestFocus();
      return;
    }

    final bool? confirm = await CustomDialog().showAlertDialog(
      context,
      "입고 등록",
      "입고일: ${Utility().pasteTextToDate(CustomDatePickerController.to.date)}\n공급처: $supplier\n생두: $selectedBean\n입고량: ${weightTECtrl.text}kg\n\n입력하신 정보로 입고를 등록합니다.",
      acceptTitle: "등록하기",
    );

    if (confirm != true) {
      return;
    } else {
      String date = CustomDatePickerController.to.date;
      String weight = weightTECtrl.text.replaceAll(".", "");
      String history = jsonEncode([
        {
          "date": date,
          "company": supplier,
          "weight": weight,
        },
      ]);

      Map<String, String> value = {
        "name": selectedBean,
        "weight": weight,
        "history": history,
      };

      final insertResult = await GreenBeanStockSqfLite().insertGreenBeanStock(value);

      if (!context.mounted) return;
      CustomDialog().showSnackBar(
        context,
        insertResult
            ? "${Utility().pasteTextToDate(CustomDatePickerController.to.date)}\n$supplier\n$selectedBean\n${weightTECtrl.text}kg\n\n입고 등록이 완료되었습니다."
            : "입고 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
        isError: insertResult ? false : true,
      );

      if (insertResult) {
        weightTECtrl.clear();
        FocusScopeNode currentFocus = FocusScope.of(context);
        await getSuppliers();
        currentFocus.unfocus();
      }
    }
  }

  /// 로스팅 관리 > 블렌드 > 생두 목록 추가하기
  void addBlendBeanList(String value) {
    bool dupCheck = false;
    if (_blendBeanList.isNotEmpty) {
      dupCheck = _blendBeanList.any((e) => e.toString() == value);
    }
    if (dupCheck) {
      return;
    }
    _opacityList.add(0.0);
    addWeightCtrlList();
    final addElement = Rxn<String>();
    addElement(value);
    _blendBeanList.add(addElement);
    calculateOpacity();
  }

  /// 로스팅 관리 > 블렌드 > 생두 목록 삭제하기
  void deleteBlendBeanList(int index) {
    _blendBeanList.removeAt(index);
    weightTECtrlList[index].dispose();
    weightTECtrlList.removeAt(index);
    weightFNList[index].dispose();
    weightFNList.removeAt(index);
  }

  /// 로스팅 관리 > 블렌드 > 생두 추가 시 컨트롤러, 포커스노드 추가하기
  void addWeightCtrlList() {
    final weightTECtrl = TextEditingController();
    final weightFN = FocusNode();
    weightTECtrlList.add(weightTECtrl);
    weightFNList.add(weightFN);
  }

  /// 로스팅 관리 > 블렌드 정보 초기화하기
  void initBlendInfo() {
    _blendBeanList.clear();
    weightTECtrlList.clear();
    weightFNList.clear();
  }

  /// 로스팅 관리 > 블렌드 로스팅 : 원두 리스트 항목 삭제하기
  void deleteBlendBeanListItem(int index) {
    _blendBeanList.removeAt(index);
    _weightFNList.removeAt(index);
    _weightTECtrlList.removeAt(index);
    _opacityList.removeAt(index);
  }

  /// 25-03-07
  ///
  /// 생두 입고 관리 > 공급처(업체명) 전체 가져오기
  Future<void> getSuppliers() async {
    List greenCoffeeBeansInventory = await GreenBeanStockSqfLite().getGreenBeanStock();
    _suppliers.clear();
    if (greenCoffeeBeansInventory.isNotEmpty) {
      Set duplicateSupplier = {};
      for (final supplier in greenCoffeeBeansInventory) {
        final decodingHistory = jsonDecode(supplier["history"]);
        for (final history in decodingHistory) {
          duplicateSupplier.add(history["company"]);
        }
      }
      _suppliers(Utility().sortHangulAscending(duplicateSupplier.toList()));
    }
  }

  /// 25-03-11
  ///
  /// 생두 입고 관리 > 공급처(업체명) 입력에 따른 추천 목록 가져오기
  void getSupplierSuggestions(String value) {
    List list = [];
    for (final supplier in suppliers) {
      if (supplier.contains(value)) list.add(supplier);
    }
    _supplierSuggestions(list);
  }

  /// 25-03-11
  ///
  /// 블렌드명 TextField 선택 시 블렌드명 전체 목록 할당하기
  void setAllSuppliers(TextEditingController ctrl) {
    if (ctrl.text == "") {
      _supplierSuggestions(suppliers);
    }
  }

  /// 25-03-11
  ///
  /// 로스팅 관리 > 블렌드명 전체 가져오기
  Future<void> getBlendNames() async {
    List roastedBeans = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    _blendNames.clear();
    if (roastedBeans.isNotEmpty) {
      Set duplicateName = {};
      for (final item in roastedBeans) {
        if (item["type"] == "2") duplicateName.add(item["name"]);
      }
      _blendNames(Utility().sortHangulAscending(duplicateName.toList()));
    }
  }

  /// 25-03-11
  ///
  /// 로스팅 관리 > 블렌드명 입력에 따른 추천 목록 가져오기🥦
  void getBlendNameSuggestions(String value) {
    List list = [];
    for (final name in blendNames) {
      if (name.contains(value)) list.add(name);
    }
    _blendNameSuggestions(list);
  }

  /// 25-03-11
  ///
  /// 블렌드명 TextField 선택 시 블렌드명 전체 목록 할당하기🥦
  void setAllBlendNames(TextEditingController ctrl) {
    if (ctrl.text == "") {
      _blendNameSuggestions(blendNames);
    }
  }

  /// 25-03-11
  ///
  /// 블렌드 로스팅 > 투입 생두 목록 UI 투명도 계산하기
  Future calculateOpacity() async {
    if (blendBeanList.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _opacityList[opacityList.length - 1] = 1.0;
      });
    }
  }

  /// 25-03-12
  ///
  /// 투명도 배열 초기화하기
  void resetOpacityList() => _opacityList.clear();
}
