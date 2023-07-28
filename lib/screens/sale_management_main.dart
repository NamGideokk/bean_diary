import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:bean_diary/controller/roasting_bean_sales_controller.dart';
import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/weight_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleManagementMain extends StatefulWidget {
  const SaleManagementMain({Key? key}) : super(key: key);

  @override
  State<SaleManagementMain> createState() => _SaleManagementMainState();
}

class _SaleManagementMainState extends State<SaleManagementMain> {
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  final RoastingBeanSalesController _roastingBeanSalesCtrl = Get.put(RoastingBeanSalesController());
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void allValueInit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _customDatePickerCtrl.setDateToToday();
    _roastingBeanSalesCtrl.companyTECtrl.clear();
    _roastingBeanSalesCtrl.weightTECtrl.clear();
  }

  void onTapSalesButton() async {
    if (_roastingBeanSalesCtrl.companyTECtrl.text.trim() == "") {
      CustomDialog().showFloatingSnackBar(context, "판매처(업체명)를 입력해 주세요.");
      _roastingBeanSalesCtrl.companyFN.requestFocus();
      return;
    }
    if (_roastingBeanSalesCtrl.selectedBean == null) {
      CustomDialog().showFloatingSnackBar(context, "판매할 원두를 선택해 주세요.");
      return;
    }
    if (_roastingBeanSalesCtrl.weightTECtrl.text.trim() == "") {
      CustomDialog().showFloatingSnackBar(context, "판매 중량을 입력해 주세요.");
      return;
    } else {
      var result = Utility().checkWeightRegEx(_roastingBeanSalesCtrl.weightTECtrl.text.trim());
      _roastingBeanSalesCtrl.weightTECtrl.text = result["replaceValue"];

      if (!result["bool"]) {
        CustomDialog().showFloatingSnackBar(context, "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.");
        _roastingBeanSalesCtrl.weightFN.requestFocus();
        return;
      } else {
        int beanTotalWeight = int.parse(_roastingBeanSalesCtrl.selectedBean.toString().split(" / ")[1].replaceAll(RegExp("[.kg]"), ""));
        int salesWeight = int.parse(_roastingBeanSalesCtrl.weightTECtrl.text.replaceAll(".", ""));
        if (beanTotalWeight <= salesWeight) {
          CustomDialog().showFloatingSnackBar(context, "판매 중량이 재고량과 같거나 클 수 없습니다.\n다시 입력해 주세요.");
          _roastingBeanSalesCtrl.weightFN.requestFocus();
          return;
        }
      }
    }

    String name = _roastingBeanSalesCtrl.selectedBean.toString().split(" / ")[0];
    String type = "1";
    _roastingBeanSalesCtrl.beanMapDataList.forEach((e) {
      if (name == e["name"]) type = e["type"].toString();
    });
    String sales_weight = _roastingBeanSalesCtrl.weightTECtrl.text.trim().replaceAll(".", "");
    String company = _roastingBeanSalesCtrl.companyTECtrl.text.trim();
    String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");

    // 등록할 데이터
    Map<String, String> value = {
      "name": name,
      "type": type,
      "sales_weight": sales_weight,
      "company": company,
      "date": date,
    };
    bool result = await RoastingBeanSalesSqfLite().insertRoastingBeanSales(value);

    if (result) {
      String successMsg = "${_customDatePickerCtrl.textEditingCtrl.text}\n$company\n${type == "1" ? "싱글오리진" : "블렌드"} - $name\n${_roastingBeanSalesCtrl.weightTECtrl.text.trim()}kg\n판매 등록이 완료되었습니다.";
      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(context, successMsg, bgColor: Colors.green);
      bool updateWeightResult = await RoastingBeanStockSqfLite().updateWeightRoastingBeanStock(value);
      if (!updateWeightResult) {
        if (!mounted) return;
        CustomDialog().showFloatingSnackBar(context, "판매한 원두의 재고량 차감이 실패했습니다.");
      }
      _roastingBeanSalesCtrl.updateBeanListWeight(_roastingBeanSalesCtrl.selectedBean, sales_weight);
      allValueInit();
      return;
    } else {
      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(context, "판매 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.");
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<WarehousingGreenBeanController>();
    Get.delete<CustomDatePickerController>();
    Get.delete<RoastingBeanSalesController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("판매 관리"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                controller: _scrollCtrl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderTitle(title: "판매 일자", subTitle: "sale day"),
                    const CustomDatePicker(),
                    const SizedBox(height: 20),
                    const HeaderTitle(title: "판매처", subTitle: "company name"),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: _roastingBeanSalesCtrl.companyTECtrl,
                      focusNode: _roastingBeanSalesCtrl.companyFN,
                      decoration: const InputDecoration(
                        hintText: "업체명",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const HeaderTitle(title: "판매 원두 정보", subTitle: "roasting bean sale information"),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: BeanSelectDropdownButton(listType: 1),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _roastingBeanSalesCtrl.weightTECtrl,
                            focusNode: _roastingBeanSalesCtrl.weightFN,
                            decoration: const InputDecoration(
                              hintText: "판매 중량",
                              suffixText: "kg",
                            ),
                            onTap: () => Utility().moveScrolling(_scrollCtrl),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const WeightAlert(),
                    SizedBox(height: height / 9),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: ColorsList().bgColor,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              bool confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                              if (confirm) allValueInit();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            ),
                            child: Text(
                              "초기화",
                              style: TextStyle(
                                fontSize: height / 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onTapSalesButton,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              ),
                              child: Text(
                                "판매",
                                style: TextStyle(
                                  fontSize: height / 50,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
