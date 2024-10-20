import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RoastingBeanSalesController extends GetxController {
  final companyTECtrl = TextEditingController();
  final weightTECtrl = TextEditingController();

  final companyFN = FocusNode();
  final weightFN = FocusNode();

  final RxList _beanList = <String?>[].obs;
  final RxList _beanMapDataList = [].obs;
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

  void setSelectBean(String value) => _selectedBean(value);

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

  void onTapSalesButton(BuildContext context) async {
    if (companyTECtrl.text.trim() == "") {
      CustomDialog().showSnackBar(context, "판매처(업체명)를 입력해 주세요.");
      companyFN.requestFocus();
      return;
    }
    if (selectedBean == null) {
      CustomDialog().showSnackBar(context, "판매할 원두를 선택해 주세요.");
      return;
    }
    if (weightTECtrl.text.trim() == "") {
      CustomDialog().showSnackBar(context, "판매 중량을 입력해 주세요.");
      weightFN.requestFocus();
      return;
    } else {
      final Map<String, dynamic> result = Utility().checkWeightRegEx(weightTECtrl.text.trim());
      weightTECtrl.text = result["replaceValue"];

      if (!result["bool"]) {
        CustomDialog().showSnackBar(context, "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.");
        weightFN.requestFocus();
        return;
      } else {
        int beanTotalWeight = int.parse(selectedBean.toString().split(" / ")[1].replaceAll(RegExp("[.,kg]"), ""));
        int salesWeight = int.parse(weightTECtrl.text.replaceAll(".", ""));
        if (beanTotalWeight < salesWeight) {
          CustomDialog().showSnackBar(context, "판매 중량이 재고량보다 클 수 없습니다.\n다시 입력해 주세요.");
          weightFN.requestFocus();
          return;
        }
      }
    }

    final customDatePickerCtrl = Get.find<CustomDatePickerController>();
    String name = selectedBean.toString().split(" / ")[0];
    String company = companyTECtrl.text.trim();

    final bool? confirm = await CustomDialog().showAlertDialog(
      context,
      "판매 등록",
      "판매일: ${customDatePickerCtrl.textEditingCtrl.text}\n판매처: $company\n원두: $name\n판매량: ${weightTECtrl.text}kg\n\n입력하신 정보로 판매를 등록합니다.",
      acceptTitle: "등록하기",
    );

    if (confirm != true) {
      return;
    } else {
      String type = "1";
      beanMapDataList.forEach((e) {
        if (name == e["name"]) type = e["type"].toString();
      });
      String salesWeight = weightTECtrl.text.trim().replaceAll(".", "");
      String date = customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");

      // 등록할 데이터
      Map<String, String> value = {
        "name": name,
        "type": type,
        "sales_weight": salesWeight,
        "company": company,
        "date": date,
      };
      bool result = await RoastingBeanSalesSqfLite().insertRoastingBeanSales(value);

      if (result) {
        String successMsg = "${customDatePickerCtrl.textEditingCtrl.text}\n$company\n${type == "1" ? "싱글오리진" : "블렌드"} - $name\n${Utility().numberFormat(weightTECtrl.text.trim())}kg\n판매 등록이 완료되었습니다.";
        if (!context.mounted) return;
        CustomDialog().showSnackBar(context, successMsg);
        bool updateWeightResult = await RoastingBeanStockSqfLite().updateWeightRoastingBeanStock(value);
        if (!updateWeightResult) {
          if (!context.mounted) return;
          CustomDialog().showSnackBar(context, "판매한 원두의 재고량 차감이 실패했습니다.");
        } else {
          updateBeanListWeight(selectedBean, salesWeight);
          weightTECtrl.clear();
        }
        return;
      } else {
        if (!context.mounted) return;
        CustomDialog().showSnackBar(context, "판매 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.");
        FocusScope.of(context).requestFocus(FocusNode());
        return;
      }
    }
  }

  /// 모든 정보 초기화하기
  void allValueInit() async {
    final customDatePickerCtrl = Get.find<CustomDatePickerController>();
    customDatePickerCtrl.setDateToToday();
    companyTECtrl.clear();
    weightTECtrl.clear();
  }
}
