import 'dart:convert';

import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RoastingManagementController extends GetxController {
  final scrollCtrl = ScrollController();

  // 싱글오리진
  final singleInputWeightTECtrl = TextEditingController();
  final singleOutputWeightTECtrl = TextEditingController();
  final singleInputWeightFN = FocusNode();
  final singleOutputWeightFN = FocusNode();

  // 블렌드
  final blendNameTECtrl = TextEditingController();
  final blendNameFN = FocusNode();
  final RxList _blendInputWeightTECtrlList = [].obs;
  final RxList _blendInputWeightFNList = [].obs;
  final blendOutputWeightTECtrl = TextEditingController();
  final blendOutputWeightFN = FocusNode();

  final RxInt _roastingType = 1.obs; // 1 = 싱글오리진, 2 = 블렌드
  final RxList _blendNames = [].obs; // 블렌드명 전체 목록
  final RxList _blendNameSuggestions = [].obs; // 블렌드명 추천 목록
  final RxList _blendInputGreenBeans = [].obs;

  final RxMap<String, int> _revokeData = <String, int>{}.obs; // 싱글오리진 취소
  final RxList<Map<String, int>> _revokeGreenBeans = <Map<String, int>>[].obs; // 블렌드 취소

  final RxList _opacityList = [].obs;

  get blendInputWeightTECtrlList => _blendInputWeightTECtrlList;

  get blendInputWeightFNList => _blendInputWeightFNList;

  get roastingType => _roastingType.value;

  get blendNames => _blendNames;

  get blendNameSuggestions => _blendNameSuggestions;

  get blendInputGreenBeans => _blendInputGreenBeans;

  get revokeData => _revokeData;
  get revokeGreenBeans => _revokeGreenBeans;

  get opacityList => _opacityList;

  /// 25-03-11
  ///
  /// 로스팅 관리 > 블렌드명 전체 가져오기
  Future<void> getBlendNames() async {
    List roastedBeans = await RoastedBeanInventorySqfLite().getRoastedBeanInventory();
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
  /// 블렌드명 TextField 선택 시 블렌드명 전체 목록 할당하기
  void setAllBlendNames() {
    if (blendNameTECtrl.text == "") {
      _blendNameSuggestions(blendNames);
    }
  }

  /// 25-03-11
  ///
  /// 로스팅 관리 > 블렌드명 입력에 따른 추천 목록 가져오기
  void getBlendNameSuggestions() {
    List list = [];
    for (final name in blendNames) {
      if (name.contains(blendNameTECtrl.text)) list.add(name);
    }
    _blendNameSuggestions(list);
  }

  /// 25-03-16
  ///
  /// 로스팅 타입 값 설정하기 (싱글오리진/블렌드)
  void setRoastingType(int value) => _roastingType(value);

  /// 25-03-17
  ///
  /// 로스팅 관리 > 블렌드 > 투입 생두 목록 추가하기
  void addInputGreenBeans(String value) {
    bool dupCheck = false;
    if (blendInputGreenBeans.isNotEmpty) {
      dupCheck = blendInputGreenBeans.any((e) => e.toString() == value);
    }
    if (dupCheck) return;

    _opacityList.add(0.0);
    addTECtrlAndFN();
    _blendInputGreenBeans.add(value);
    calculateOpacity();
  }

  /// 25-03-17
  ///
  /// 로스팅 관리 > 블렌드 > 투입 생두 추가 시 컨트롤러, 포커스노드 추가하기
  void addTECtrlAndFN() {
    final inputWeightTECtrl = TextEditingController();
    final inputWeightFN = FocusNode();
    _blendInputWeightTECtrlList.add(inputWeightTECtrl);
    _blendInputWeightFNList.add(inputWeightFN);
  }

  /// 25-03-17
  ///
  /// 로스팅 관리 > 블렌드 > 투입 생두 목록 항목 삭제하기
  void deleteBlendBeanListItem(int index) {
    _blendInputGreenBeans.removeAt(index);
    _blendInputWeightTECtrlList.removeAt(index);
    _blendInputWeightFNList.removeAt(index);
    _opacityList.removeAt(index);
  }

  /// 25-03-11
  ///
  /// 블렌드 로스팅 > 투입 생두 목록 UI 투명도 계산하기
  Future calculateOpacity() async {
    if (blendInputGreenBeans.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _opacityList[opacityList.length - 1] = 1.0;
      });
    }
  }

  /// 25-03-12
  ///
  /// 투명도 배열 초기화하기
  void resetOpacityList() => _opacityList.clear();

  /// 25-03-14
  ///
  /// 싱글오리진 로스팅 등록하기
  Future registerSingleOriginRoasting(BuildContext context) async {
    if (BeanSelectionDropdownController.to.selectedBean == null) {
      CustomDialog().showSnackBar(context, "투입할 생두를 선택해 주세요.", isError: true);
      FocusScope.of(context).unfocus();
      return;
    }
    if (singleInputWeightTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "투입량을 입력해 주세요.", isError: true);
      singleInputWeightFN.requestFocus();
      Utility().moveScrolling(scrollCtrl);
      return;
    } else {
      bool weightIsValid = Utility().checkRegExpWeight(singleInputWeightTECtrl.text);
      if (weightIsValid) {
        singleInputWeightTECtrl.text = Utility().hasDecimalPointInWeight(singleInputWeightTECtrl.text);
        // 투입량 유효성 검사
        bool weightIsValid2 = Utility().validateInputWeight(
          BeanSelectionDropdownController.to.selectedBean,
          singleInputWeightTECtrl.text,
        );
        if (!weightIsValid2) {
          CustomDialog().showSnackBar(context, "투입량이 생두의 보유량보다 높습니다.\n다시 입력해 주세요.", isError: true);
          singleInputWeightFN.requestFocus();
          Utility().moveScrolling(scrollCtrl);
          return;
        }
      } else {
        CustomDialog().showSnackBar(context, "투입량의 입력 형식이 잘못되었습니다.\n아래의 중량 입력 안내에 맞게 다시 입력해 주세요.", isError: true);
        singleInputWeightFN.requestFocus();
        Utility().moveScrolling(scrollCtrl);
        return;
      }
    }
    if (singleOutputWeightTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "배출량을 입력해 주세요.", isError: true);
      singleOutputWeightFN.requestFocus();
      Utility().moveScrolling(scrollCtrl);
      return;
    } else {
      bool weightIsValid = Utility().checkRegExpWeight(singleOutputWeightTECtrl.text);
      if (weightIsValid) {
        singleOutputWeightTECtrl.text = Utility().hasDecimalPointInWeight(singleOutputWeightTECtrl.text);
        // 배출량 유효성 검사
        bool outputIsValid = Utility().validateOutputWeight(singleInputWeightTECtrl.text, singleOutputWeightTECtrl.text);
        if (!outputIsValid) {
          CustomDialog().showSnackBar(context, "배출량이 투입량보다 크거나 같을 수 없습니다. 다시 입력해 주세요.", isError: true);
          singleOutputWeightFN.requestFocus();
          Utility().moveScrolling(scrollCtrl);
          return;
        }
      } else {
        CustomDialog().showSnackBar(context, "배출량의 입력 형식이 잘못되었습니다.\n아래의 중량 입력 안내에 맞게 다시 입력해 주세요.", isError: true);
        singleOutputWeightFN.requestFocus();
        Utility().moveScrolling(scrollCtrl);
        return;
      }
    }

    // 로스팅 등록 유효성 모두 통과
    clearAllFocusingInSingleOrigin();

    String date = CustomDatePickerController.to.date;
    String beanName = BeanSelectionDropdownController.to.selectedBean.split(" / ")[0];
    String inputWeight = singleInputWeightTECtrl.text.replaceAll(".", "");
    String roastingWeight = singleOutputWeightTECtrl.text.replaceAll(".", "");

    bool? finalConfirm = await CustomDialog().showAlertDialog(
      context,
      "싱글오리진 - 로스팅 등록",
      "로스팅일자 : ${Utility().pasteTextToDate(CustomDatePickerController.to.date)}\n생두명 : $beanName\n투입량 : ${Utility().numberFormat(singleInputWeightTECtrl.text)}kg\n배출량 : ${Utility().numberFormat(singleOutputWeightTECtrl.text)}kg\n\n입력하신 정보로 로스팅을 등록합니다.",
      acceptTitle: "등록하기",
    );

    if (finalConfirm == true) {
      // 생두 재고 차감
      final decreaseInventoryResult = await GreenBeanInventorySqfLite().decreaseInventory({
        "name": beanName,
        "weight": int.parse(inputWeight),
      });

      if (decreaseInventoryResult != null) {
        // 원두 재고 등록
        final insertResult = await RoastedBeanInventorySqfLite().insertRoastedBeanInventory({
          "type": "1",
          "name": beanName,
          "inventory_weight": int.parse(roastingWeight),
        });

        if (insertResult != null) {
          // 히스토리 등록
          final insertHistoryResult = await RoastedBeanInventoryHistorySqfLite().insertRoastedBeanInventoryHistory({
            "roasted_bean_id": insertResult,
            "name": beanName,
            "date": date,
            "weight": int.parse(roastingWeight),
          });

          if (insertHistoryResult != null) {
            _revokeData.addAll({
              "greenBeanID": decreaseInventoryResult,
              "roastedBeanID": insertResult,
              "historyID": insertHistoryResult,
              "input_weight": int.parse(inputWeight),
              "output_weight": int.parse(roastingWeight),
            });
            if (context.mounted) {
              CustomDialog().showRegisterSingleOriginRoastingResultSnackBar(context, {
                "date": Utility().pasteTextToDate(date),
                "selectedBean": BeanSelectionDropdownController.to.selectedBean.split(" / ")[0],
                "inputWeight": "${Utility().numberFormat(singleInputWeightTECtrl.text)}kg",
                "outputWeight": "${Utility().numberFormat(singleOutputWeightTECtrl.text)}kg",
              });
            }
            singleInputWeightTECtrl.clear();
            singleOutputWeightTECtrl.clear();
            BeanSelectionDropdownController.to.resetSelectedBean();
            await BeanSelectionDropdownController.to.getBeans(ListType.greenBeanInventory);
          } else {
            if (context.mounted) {
              CustomDialog().showSnackBar(
                context,
                "로스팅 내역 등록에 실패헀습니다.\n잠시 후 다시 시도해 주세요.",
                isError: true,
              );
            }
            return;
          }
        } else {
          if (context.mounted) {
            CustomDialog().showSnackBar(
              context,
              "로스팅 등록에 실패헀습니다.\n잠시 후 다시 시도해 주세요.",
              isError: true,
            );
          }
          return;
        }
      } else {
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "생두 재고 차감에 실패헀습니다.\n잠시 후 다시 시도해 주세요.",
            isError: true,
          );
        }
        return;
      }
    }
  }

  /// 25-03-17
  ///
  /// 블렌드 로스팅 등록하기
  Future registerBlendRoasting(BuildContext context) async {
    if (blendNameTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "블렌드명을 입력해 주세요.", isError: true);
      setAllBlendNames();
      blendNameFN.requestFocus();
      return;
    }
    if (blendInputGreenBeans.isEmpty) {
      CustomDialog().showSnackBar(context, "투입할 생두를 선택해 주세요.", isError: true);
      FocusScope.of(context).unfocus();
      return;
    } else {
      // 투입 생두 목록 유효성 검사
      for (int i = 0; i < blendInputGreenBeans.length; i++) {
        if (blendInputWeightTECtrlList[i].text == "") {
          CustomDialog().showSnackBar(context, "투입량을 입력해 주세요.", isError: true);
          blendInputWeightFNList[i].requestFocus();
          return;
        } else {
          bool weightIsValid = Utility().checkRegExpWeight(blendInputWeightTECtrlList[i].text);
          if (weightIsValid) {
            blendInputWeightTECtrlList[i].text = Utility().hasDecimalPointInWeight(blendInputWeightTECtrlList[i].text);
            // 투입량 유효성 검사
            bool weightIsValid2 = Utility().validateInputWeight(
              blendInputGreenBeans[i],
              blendInputWeightTECtrlList[i].text,
            );
            if (!weightIsValid2) {
              CustomDialog().showSnackBar(context, "투입량이 생두의 보유량보다 높습니다.\n다시 입력해 주세요.", isError: true);
              blendInputWeightFNList[i].requestFocus();
              return;
            }
          } else {
            CustomDialog().showSnackBar(context, "투입량의 입력 형식이 잘못되었습니다.\n아래의 중량 입력 안내에 맞게 다시 입력해 주세요.", isError: true);
            blendInputWeightFNList[i].requestFocus();
            return;
          }
        }
      }
    }
    if (blendOutputWeightTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "배출량을 입력해 주세요.", isError: true);
      blendOutputWeightFN.requestFocus();
      Utility().moveScrolling(scrollCtrl);
      return;
    } else {
      bool weightIsValid = Utility().checkRegExpWeight(blendOutputWeightTECtrl.text);
      if (weightIsValid) {
        blendOutputWeightTECtrl.text = Utility().hasDecimalPointInWeight(blendOutputWeightTECtrl.text);
        // 배출량 유효성 검사
        int totalInputWeight = 0;
        for (final ctrl in blendInputWeightTECtrlList) {
          totalInputWeight += int.parse(ctrl.text.replaceAll(".", ""));
        }
        bool outputIsValid = Utility().validateOutputWeight(totalInputWeight.toString(), blendOutputWeightTECtrl.text);
        if (!outputIsValid) {
          CustomDialog().showSnackBar(context, "배출량이 투입량보다 크거나 같을 수 없습니다. 다시 입력해 주세요.", isError: true);
          blendOutputWeightFN.requestFocus();
          Utility().moveScrolling(scrollCtrl);
          return;
        }
      } else {
        CustomDialog().showSnackBar(context, "배출량의 입력 형식이 잘못되었습니다.\n아래의 중량 입력 안내에 맞게 다시 입력해 주세요.", isError: true);
        blendOutputWeightFN.requestFocus();
        Utility().moveScrolling(scrollCtrl);
        return;
      }
    }

    // 로스팅 등록 유효성 모두 통과
    blendNameFN.unfocus();
    for (final focus in blendInputWeightFNList) {
      focus.unfocus();
    }
    blendOutputWeightFN.unfocus();

    String date = CustomDatePickerController.to.date.replaceAll(RegExp("[년 월 일 ]"), "-");
    String roastingWeight = blendOutputWeightTECtrl.text.replaceAll(".", "");

    String beans = "";
    for (int i = 0; i < blendInputGreenBeans.length; i++) {
      String copyItem = blendInputGreenBeans[i].toString();
      if (i == 0) {
        beans = "생두 01 : ${copyItem.split(" / ")[0]} / ${Utility().numberFormat(blendInputWeightTECtrlList[i].text)}kg";
      } else {
        beans = "$beans\n생두 ${(i + 1).toString().padLeft(2, "0")} : ${copyItem.split(" / ")[0]} / ${Utility().numberFormat(blendInputWeightTECtrlList[i].text)}kg";
      }
    }

    bool? finalConfirm = await CustomDialog().showAlertDialog(
      context,
      "블렌드 - 로스팅 등록",
      "로스팅일자 : ${Utility().pasteTextToDate(CustomDatePickerController.to.date)}\n블렌드명 : ${blendNameTECtrl.text}\n$beans\n배출량 : ${Utility().numberFormat(blendOutputWeightTECtrl.text)}kg\n\n입력하신 정보로 로스팅을 등록합니다.",
      acceptTitle: "등록하기",
    );
    if (finalConfirm != true) return;

    // 생두 재고 차감
    List decreaseResults = [];
    for (int i = 0; i < blendInputGreenBeans.length; i++) {
      final decreaseResult = await GreenBeanInventorySqfLite().decreaseInventory({
        "name": Utility().splitNameAndWeight(blendInputGreenBeans[i], 1),
        "weight": int.parse(blendInputWeightTECtrlList[i].text.replaceAll(".", "")),
      });
      decreaseResults.add(decreaseResult);
    }
    if (!decreaseResults.any((e) => e == null)) {
      // 원두 재고 등록
      final insertResult = await RoastedBeanInventorySqfLite().insertRoastedBeanInventory({
        "type": "2",
        "name": blendNameTECtrl.text,
        "inventory_weight": int.parse(roastingWeight),
      });

      if (insertResult != null) {
        // 히스토리 등록
        final insertHistoryResult = await RoastedBeanInventoryHistorySqfLite().insertRoastedBeanInventoryHistory({
          "roasted_bean_id": insertResult,
          "name": blendNameTECtrl.text,
          "date": date,
          "weight": int.parse(roastingWeight),
        });

        if (insertHistoryResult != null) {
          _revokeData.addAll({
            "roastedBeanID": insertResult,
            "historyID": insertHistoryResult,
            "output_weight": int.parse(roastingWeight),
          });
          for (int i = 0; i < blendInputGreenBeans.length; i++) {
            _revokeGreenBeans.add({
              "greenBeanID": decreaseResults[i],
              "input_weight": int.parse(blendInputWeightTECtrlList[i].text.replaceAll(".", "")),
            });
          }

          List inputList = [];
          for (int i = 0; i < blendInputGreenBeans.length; i++) {
            inputList.add("${blendInputGreenBeans[i].split(" / ")[0]} / ${Utility().numberFormat(blendInputWeightTECtrlList[i].text)}kg");
          }

          if (context.mounted) {
            CustomDialog().showRegisterBlendRoastingResultSnackBar(context, {
              "date": Utility().pasteTextToDate(date),
              "blendName": blendNameTECtrl.text,
              "inputList": inputList,
              "outputWeight": "${Utility().numberFormat(blendOutputWeightTECtrl.text)}kg",
            });
          }
          for (int i = 0; i < _blendInputGreenBeans.length; i++) {
            blendInputWeightTECtrlList[i].dispose();
            blendInputWeightFNList[i].dispose();
          }
          blendNameTECtrl.clear();
          _blendInputGreenBeans.clear();
          _blendInputWeightTECtrlList.clear();
          _blendInputWeightFNList.clear();
          _opacityList.clear();
          blendOutputWeightTECtrl.clear();
          await getBlendNames();
          await BeanSelectionDropdownController.to.getBeans(ListType.greenBeanInventory);
          // 블렌드 로스팅 등록 완료
        } else {
          if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록에 실패헀습니다.\n잠시 후 다시 시도해 주세요.", isError: true);
          return;
        }
      } else {
        if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 등록에 실패헀습니다.\n잠시 후 다시 시도해 주세요.", isError: true);
        return;
      }
    } else {
      if (context.mounted) CustomDialog().showSnackBar(context, "생두 재고 차감에 실패헀습니다.\n잠시 후 다시 시도해 주세요.", isError: true);
      return;
    }
    return;
  }

  /// 25-03-18
  ///
  /// 모든 입력 정보 초기화하기
  void clearData(BuildContext context) {
    CustomDatePickerController.to.setDateToToday();
    if (roastingType == 1) {
      BeanSelectionDropdownController.to.resetSelectedBean();
      singleInputWeightFN.unfocus();
      singleOutputWeightFN.unfocus();
      singleInputWeightTECtrl.clear();
      singleOutputWeightTECtrl.clear();
    } else {
      blendNameTECtrl.clear();
      for (int i = 0; i < blendInputGreenBeans.length; i++) {
        _blendInputWeightTECtrlList[i].dispose();
        _blendInputWeightFNList[i].dispose();
      }
      _blendInputGreenBeans.clear();
      _blendInputWeightTECtrlList.clear();
      _blendInputWeightFNList.clear();
      _opacityList.clear();
      blendOutputWeightTECtrl.clear();
    }
  }

  /// 25-03-24
  ///
  /// 싱글오리진 페이지 모든 포커싱 해제하기
  void clearAllFocusingInSingleOrigin() {
    singleInputWeightFN.unfocus();
    singleOutputWeightFN.unfocus();
  }

  /// 25-03-24
  ///
  /// 싱글오리진 - 로스팅 등록 내역 취소하기
  Future revokeRecentInsert(BuildContext context) async {
    final deleteHistoryResult = await RoastedBeanInventoryHistorySqfLite().deleteHistory(revokeData["historyID"]);

    if (deleteHistoryResult != null) {
      final hasHistory = await RoastedBeanInventoryHistorySqfLite().getInventoryHistories(revokeData["roastedBeanID"]);
      // 히스토리 없으면 아예 삭제, 히스토리 있으면 재고 차감
      if (hasHistory.isNotEmpty) {
        final revokeRecent = await RoastedBeanInventorySqfLite().revokeRecentInventoryRoasting(revokeData);
        if (revokeRecent == null) {
          if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
          return;
        }
      } else {
        final deleteRoastedBean = await RoastedBeanInventorySqfLite().deleteRoastedBean(revokeData["roastedBeanID"]);
        if (deleteRoastedBean == null) {
          if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
          return;
        }
      }
      // 생고 재고 롤백
      final revokeDecrease = await GreenBeanInventorySqfLite().revokeDecreaseInventory(revokeData);
      if (revokeDecrease != null) {
        await BeanSelectionDropdownController.to.getBeans(ListType.greenBeanInventory);
        if (context.mounted) CustomDialog().showSnackBar(context, "싱글오리진 로스팅 등록이 취소되었습니다.");
        return;
      } else {
        if (context.mounted) CustomDialog().showSnackBar(context, "생두 재고 롤백에 실패했습니다.", isError: true);
        return;
      }
    } else {
      if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
      return;
    }
  }

  /// 25-03-25
  ///
  /// 블렌드 - 로스팅 등록 내역 취소하기
  Future revokeRecentBlendInsert(BuildContext context) async {
    final deleteHistoryResult = await RoastedBeanInventoryHistorySqfLite().deleteHistory(revokeData["historyID"]);

    if (deleteHistoryResult != null) {
      final hasHistory = await RoastedBeanInventoryHistorySqfLite().getInventoryHistories(revokeData["roastedBeanID"]);
      // 히스토리 없으면 아예 삭제, 히스토리 있으면 재고 차감
      if (hasHistory.isNotEmpty) {
        final revokeRecent = await RoastedBeanInventorySqfLite().revokeRecentInventoryRoasting(revokeData);
        if (revokeRecent == null) {
          if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
          return;
        }
      } else {
        final deleteRoastedBean = await RoastedBeanInventorySqfLite().deleteRoastedBean(revokeData["roastedBeanID"]);
        if (deleteRoastedBean == null) {
          if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
          return;
        }
      }
      // 생고 재고 롤백
      List revokeResults = [];
      for (final e in revokeGreenBeans) {
        final revokeDecrease = await GreenBeanInventorySqfLite().revokeDecreaseInventory(e);
        revokeResults.add(revokeDecrease);
      }
      if (revokeResults.every((e) => e > 0)) {
        await BeanSelectionDropdownController.to.getBeans(ListType.greenBeanInventory);
        await getBlendNames();
        if (context.mounted) CustomDialog().showSnackBar(context, "블렌드 로스팅 등록이 취소되었습니다.");
        return;
      } else {
        if (context.mounted) CustomDialog().showSnackBar(context, "생두 재고 롤백에 실패했습니다.", isError: true);
        return;
      }
    } else {
      if (context.mounted) CustomDialog().showSnackBar(context, "로스팅 내역 등록 취소에 실패했습니다.", isError: true);
      return;
    }
  }
}
