import 'dart:convert';

import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GreenBeanEntryController extends GetxController {
  final scrollCtrl = ScrollController();
  final weightTECtrl = TextEditingController();
  final supplierTECtrl = TextEditingController();
  final supplierFN = FocusNode();

  // 생두 입고 관리
  final weightFN = FocusNode();

  final RxList _beanList = <String?>[].obs;

  final RxList<Map<String, dynamic>> _greenBeanStockList = <Map<String, dynamic>>[].obs;
  final RxList<Rxn<String>> _blendBeanList = <Rxn<String>>[].obs;

  final RxList _suppliers = [].obs; // 공급처 목록
  final RxList _supplierSuggestions = [].obs; // 공급처 추천 목록

  final RxBool _isLoading = true.obs;

  get beanList => _beanList;

  get greenBeanStockList => _greenBeanStockList;

  get blendBeanList => _blendBeanList;

  get suppliers => _suppliers;

  get supplierSuggestions => _supplierSuggestions;

  get isLoading => _isLoading.value;

  @override
  void onClose() {
    super.onClose();
    weightFN.dispose();
  }

  /// 생두 목록 삭제하기
  void deleteBeanList(int index) {
    List copyList = <String?>[..._beanList];
    copyList.removeAt(index);
    _beanList(copyList);
  }

  /// 생두 입고 입력 정보 초기화하기
  void clearData(BuildContext context) {
    FocusScope.of(context).unfocus();
    CustomDatePickerController.to.setDateToToday();
    supplierTECtrl.clear();
    BeanSelectionDropdownController.to.resetSelectedBean();
    weightTECtrl.clear();
  }

  /// 생두 입고 등록하기
  Future registerWarehousingGreenBean(BuildContext context) async {
    if (supplierTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "공급처(업체명)를 입력해 주세요.", isError: true);
      setAllSuppliers();
      supplierFN.requestFocus();
      return;
    }
    if (BeanSelectionDropdownController.to.selectedBean == null) {
      CustomDialog().showSnackBar(context, "생두를 선택해 주세요.", isError: true);
      FocusScope.of(context).unfocus();
      return;
    }
    if (weightTECtrl.text.trim() == "") {
      CustomDialog().showSnackBar(context, "입고량을 입력해 주세요.", isError: true);
      weightFN.requestFocus();
      Utility().moveScrolling(scrollCtrl);
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
        "중량 입력 형식이 맞지 않습니다.\n중량 입력 안내에 따라 입력해 주세요.",
        isError: true,
      );
      weightFN.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();

    String date = CustomDatePickerController.to.date;
    String greenBean = BeanSelectionDropdownController.to.selectedBean;
    String weight = weightTECtrl.text.replaceAll(".", "");

    final bool? confirm = await CustomDialog().showAlertDialog(
      context,
      "입고 등록",
      "입고일자 : ${Utility().pasteTextToDate(date)}\n공급처 : ${supplierTECtrl.text}\n생두명 : $greenBean\n입고량 : ${Utility().numberFormat(weightTECtrl.text)}kg\n\n입력하신 정보로 입고를 등록합니다.",
      acceptTitle: "등록하기",
    );

    if (confirm == true) {
      final insertResult = await GreenBeanStockSqfLite().insertGreenBeanStock({
        "name": BeanSelectionDropdownController.to.selectedBean,
        "weight": weight,
        "history": jsonEncode([
          {
            "date": date,
            "company": supplierTECtrl.text,
            "weight": weight,
          },
        ]),
      });

      if (!context.mounted) return;
      CustomDialog().showRegisterStockResultSnackBar(context, {
        "date": Utility().pasteTextToDate(date),
        "supplier": supplierTECtrl.text,
        "selectedBean": greenBean,
        "inputWeight": "${Utility().numberFormat(weightTECtrl.text)}kg",
      });

      if (insertResult) {
        weightTECtrl.clear();
        await getSuppliers();
      }
    }
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
  void getSupplierSuggestions() {
    List list = [];
    for (final supplier in suppliers) {
      if (supplier.contains(supplierTECtrl.text)) list.add(supplier);
    }
    _supplierSuggestions(list);
  }

  /// 25-03-11
  ///
  /// 공급처 TextField 선택 시 공급처(업체명) 전체 목록 할당하기
  void setAllSuppliers() {
    if (supplierTECtrl.text == "") {
      _supplierSuggestions(suppliers);
    } else {
      getSupplierSuggestions();
    }
  }
}
