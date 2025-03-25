import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SalesManagementController extends GetxController {
  final scrollCtrl = ScrollController();
  final retailerTECtrl = TextEditingController();
  final retailerFN = FocusNode();
  final salesWeightTECtrl = TextEditingController();
  final salesWeightFN = FocusNode();

  final RxList _retailers = [].obs; // 판매처 목록
  final RxList _retailerSuggestions = [].obs; // 판매처 추천 목록

  final RxMap<String, int> _revokeData = <String, int>{}.obs;

  get retailers => _retailers;
  get retailerSuggestions => _retailerSuggestions;

  get revokeData => _revokeData;

  /// 25-03-17
  ///
  /// 원두 판매 등록하기
  void registerSales(BuildContext context) async {
    if (retailerTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "판매처(업체명)를 입력해 주세요.", isError: true);
      setAllRetailers();
      retailerFN.requestFocus();
      return;
    }
    if (BeanSelectionDropdownController.to.selectedBean == null) {
      CustomDialog().showSnackBar(context, "판매할 원두를 선택해 주세요.", isError: true);
      FocusScope.of(context).unfocus();
      return;
    }
    if (salesWeightTECtrl.text == "") {
      CustomDialog().showSnackBar(context, "판매량을 입력해 주세요.", isError: true);
      salesWeightFN.requestFocus();
      Utility().moveScrolling(scrollCtrl);
      return;
    } else {
      bool weightIsValid = Utility().checkRegExpWeight(salesWeightTECtrl.text);
      if (weightIsValid) {
        salesWeightTECtrl.text = Utility().hasDecimalPointInWeight(salesWeightTECtrl.text);
        // 판매량 유효성 검사
        bool salesIsValid = Utility().validateInputWeight(BeanSelectionDropdownController.to.selectedBean, salesWeightTECtrl.text);
        if (!salesIsValid) {
          CustomDialog().showSnackBar(context, "판매량이 보유량보다 큽니다. 다시 입력해 주세요.", isError: true);
          salesWeightFN.requestFocus();
          Utility().moveScrolling(scrollCtrl);
          return;
        }
      } else {
        CustomDialog().showSnackBar(context, "판매량의 입력 형식이 잘못되었습니다.\n아래의 중량 입력 안내에 맞게 다시 입력해 주세요.", isError: true);
        salesWeightFN.requestFocus();
        Utility().moveScrolling(scrollCtrl);
        return;
      }
    }

    // 판매 등록 유효성 모두 통과
    clearAllFocusing();

    String name = Utility().splitNameAndWeight(BeanSelectionDropdownController.to.selectedBean, 1);

    final bool? confirm = await CustomDialog().showAlertDialog(
      context,
      "판매 등록",
      "판매일자 : ${Utility().pasteTextToDate(CustomDatePickerController.to.date)}\n판매처 : ${retailerTECtrl.text}\n상품명 : $name\n판매량 : ${Utility().numberFormat(salesWeightTECtrl.text)}kg\n\n입력하신 정보로 판매를 등록합니다.",
      acceptTitle: "등록하기",
    );

    if (confirm == true) {
      String type = "";
      BeanSelectionDropdownController.to.beanDataList.forEach((e) {
        if (name == e["name"]) type = e["type"].toString();
      });
      String salesWeight = salesWeightTECtrl.text.replaceAll(".", "");
      String date = CustomDatePickerController.to.date.replaceAll(RegExp("[년 월 일 ]"), "-");

      final insertResult = await RoastingBeanSalesSqfLite().insertRoastedBeanSales({
        "name": name,
        "type": type,
        "sales_weight": salesWeight,
        "company": retailerTECtrl.text,
        "date": date,
      });

      if (insertResult != null) {
        final decreaseResult = await RoastedBeanInventorySqfLite().decreaseInventory({
          "name": name,
          "weight": int.parse(salesWeight),
        });
        if (decreaseResult != null) {
          _revokeData.addAll({
            "salesID": insertResult,
            "roastedBeanID": decreaseResult,
            "salesWeight": int.parse(salesWeight),
          });

          if (context.mounted) {
            CustomDialog().showRegisterSalesResultSnackBar(context, {
              "date": Utility().pasteTextToDate(CustomDatePickerController.to.date),
              "retailer": retailerTECtrl.text,
              "selectedBean": name,
              "saleWeight": "${Utility().numberFormat(salesWeightTECtrl.text)}kg",
            });

            BeanSelectionDropdownController.to.resetSelectedBean();
            await BeanSelectionDropdownController.to.getBeans(ListType.roastedBeanInventory);
            salesWeightTECtrl.clear();
          }
        } else {
          if (context.mounted) CustomDialog().showSnackBar(context, "판매한 원두의 재고량 차감이 실패했습니다.", isError: true);
          return;
        }
      } else {
        if (context.mounted) CustomDialog().showSnackBar(context, "판매 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.");
        return;
      }
    }
  }

  /// 모든 정보 초기화하기
  void clearData(BuildContext context) async {
    clearAllFocusing();
    CustomDatePickerController.to.setDateToToday();
    retailerTECtrl.clear();
    BeanSelectionDropdownController.to.resetSelectedBean();
    salesWeightTECtrl.clear();
  }

  /// 25-03-07
  ///
  /// 판매 관리 > 판매처(업체명) 전체 가져오기
  Future<void> getRetailers() async {
    List salesHistory = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
    _retailers.clear();
    if (salesHistory.isNotEmpty) {
      Set duplicateRetailer = {};
      for (final supplier in salesHistory) {
        duplicateRetailer.add(supplier["company"]);
      }
      _retailers(Utility().sortHangulAscending(duplicateRetailer.toList()));
    }
  }

  /// 25-03-11
  ///
  /// 판매 관리 > 판매처(업체명) 입력에 따른 추천 목록 가져오기
  void getRetailerSuggestions() {
    List list = [];
    for (final retailer in retailers) {
      if (retailer.contains(retailerTECtrl.text)) list.add(retailer);
    }
    _retailerSuggestions(list);
  }

  /// 25-03-11
  ///
  /// 판매처(업체명) TextField 선택 시 판매처 전체 목록 할당하기
  void setAllRetailers() {
    if (retailerTECtrl.text == "") {
      _retailerSuggestions(retailers);
    } else {
      getRetailerSuggestions();
    }
  }

  /// 25-03-25
  ///
  /// 모든 포커싱 해제하기
  void clearAllFocusing() {
    retailerFN.unfocus();
    salesWeightFN.unfocus();
  }

  /// 25-03-24
  ///
  /// 최근 판매 등록 내역 취소하기
  Future revokeRecentInsert(BuildContext context) async {
    // 판매 히스토리 삭제
    final deleteHistoryResult = await RoastingBeanSalesSqfLite().deleteHistory(revokeData["salesID"]);
    if (deleteHistoryResult != null) {
      // 원두 재고 롤백
      final revokeResult = await RoastedBeanInventorySqfLite().revokeDecreaseInventory(revokeData);
      if (revokeResult != null) {
        await BeanSelectionDropdownController.to.getBeans(ListType.roastedBeanInventory);
        await getRetailers();
        if (context.mounted) CustomDialog().showSnackBar(context, "판매 등록이 취소되었습니다.");
        return;
      } else {
        if (context.mounted) CustomDialog().showSnackBar(context, "원두 재고량 차감 취소에 실패했습니다.", isError: true);
        return;
      }
    } else {
      if (context.mounted) CustomDialog().showSnackBar(context, "판매 내역 등록 취소에 실패했습니다.", isError: true);
      return;
    }
  }
}
